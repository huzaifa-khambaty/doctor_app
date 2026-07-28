<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Domain\Shared\Models\Query;
use App\Domain\Shared\Models\QueryCategory;
use App\Domain\Shared\Models\QueryMessage;
use App\Domain\Doctor\Http\Requests\StoreQueryThreadRequest;
use App\Domain\Shared\Http\Requests\SendQueryMessageRequest;
use App\Events\QueryThreadCreated;
use App\Events\QueryMessageSent;
use App\Events\QueryMessageRead;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class QueryController extends Controller
{
    public function categories()
    {
        $categories = QueryCategory::select('id', 'name', 'slug')->orderBy('name')->get();
        return response()->json($categories);
    }

    public function store(StoreQueryThreadRequest $request)
    {
        $user = $request->user();

        $result = DB::transaction(function () use ($request, $user) {
            $query = Query::create([
                'user_id' => $user->id,
                'query_category_id' => $request->category_id,
                'subject' => $request->subject,
                'status' => 'open',
                'last_message_at' => now(),
                'doctor_read_at' => now(),
            ]);

            $message = QueryMessage::create([
                'query_id' => $query->id,
                'sender_type' => 'doctor',
                'sender_id' => $user->id,
                'message' => $request->message,
            ]);

            if ($request->hasFile('attachments')) {
                $this->handleAttachments($message, $request->file('attachments'));
            }

            $query->load('category:id,name,slug', 'user:id,full_name');

            return ['query' => $query, 'message' => $message];
        });

        QueryThreadCreated::dispatch($result['query'], $result['message']);

        return response()->json([
            'message' => 'Query submitted successfully.',
            'data' => [
                'id' => $result['query']->id,
                'category' => [
                    'id' => $result['query']->category->id,
                    'name' => $result['query']->category->name,
                    'slug' => $result['query']->category->slug,
                ],
                'subject' => $result['query']->subject,
                'status' => $result['query']->status,
                'created_at' => $result['query']->created_at,
            ],
        ], 201);
    }

    public function myThreads(Request $request)
    {
        $queries = Query::where('user_id', $request->user()->id)
            ->with('category:id,name,slug')
            ->withCount(['messages' => function ($q) use ($request) {
                $q->where('sender_type', '!=', 'doctor')
                  ->where(function ($q2) use ($request) {
                      $q2->whereNull('created_at')
                         ->orWhere('created_at', '>', $request->user()->last_active_at ?? now()->subDays(30));
                  });
            }])
            ->with('latestMessage')
            ->orderByDesc('last_message_at')
            ->paginate($request->query('per_page', 15));

        $queries->getCollection()->transform(function ($query) use ($request) {
            return [
                'id' => $query->id,
                'category' => [
                    'id' => $query->category->id,
                    'name' => $query->category->name,
                    'slug' => $query->category->slug,
                ],
                'subject' => $query->subject,
                'status' => $query->status,
                'last_message' => $query->latestMessage ? [
                    'message' => $query->latestMessage->message,
                    'sender_type' => $query->latestMessage->sender_type,
                    'created_at' => $query->latestMessage->created_at,
                ] : null,
                'last_message_at' => $query->last_message_at,
                'created_at' => $query->created_at,
            ];
        });

        return $this->jsonWithPagination($queries);
    }

    public function show(Query $query, Request $request)
    {
        if ($query->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Query not found.'], 404);
        }

        $query->load('category:id,name,slug');
        $query->loadCount('messages');

        return response()->json([
            'id' => $query->id,
            'category' => [
                'id' => $query->category->id,
                'name' => $query->category->name,
                'slug' => $query->category->slug,
            ],
            'subject' => $query->subject,
            'status' => $query->status,
            'messages_count' => $query->messages_count,
            'last_message_at' => $query->last_message_at,
            'created_at' => $query->created_at,
        ]);
    }

    public function messages(Query $query, Request $request)
    {
        if ($query->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Query not found.'], 404);
        }

        $messages = $query->messages()
            ->with('attachments')
            ->orderByDesc('created_at')
            ->paginate($request->query('per_page', 50));

        $messages->getCollection()->transform(function ($msg) {
            $sender = $msg->sender;
            return [
                'id' => $msg->id,
                'sender_type' => $msg->sender_type,
                'sender_id' => $msg->sender_id,
                'sender_name' => $sender
                    ? ($msg->sender_type === 'doctor' ? $sender->full_name : $sender->name)
                    : 'Unknown',
                'message' => $msg->message,
                'attachments' => $msg->attachments->map(fn ($a) => [
                    'id' => $a->id,
                    'original_name' => $a->original_name,
                    'mime_type' => $a->mime_type,
                    'size' => $a->size,
                    'url' => $a->url,
                ]),
                'read_at' => $msg->read_at,
                'created_at' => $msg->created_at,
            ];
        });

        return $this->jsonWithPagination($messages);
    }

    public function sendMessage(SendQueryMessageRequest $request, Query $query)
    {
        if ($query->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Query not found.'], 404);
        }

        $result = DB::transaction(function () use ($request, $query) {
            $message = QueryMessage::create([
                'query_id' => $query->id,
                'sender_type' => 'doctor',
                'sender_id' => $request->user()->id,
                'message' => $request->message,
            ]);

            if ($request->hasFile('attachments')) {
                $this->handleAttachments($message, $request->file('attachments'));
            }

            $query->update([
                'last_message_at' => now(),
                'doctor_read_at' => now(),
            ]);

            return $message->load('attachments', 'sender');
        });

        QueryMessageSent::dispatch($result);

        return response()->json([
            'message' => 'Message sent.',
            'data' => [
                'id' => $result->id,
                'sender_type' => $result->sender_type,
                'sender_id' => $result->sender_id,
                'message' => $result->message,
                'attachments' => $result->attachments->map(fn ($a) => [
                    'id' => $a->id,
                    'original_name' => $a->original_name,
                    'mime_type' => $a->mime_type,
                    'size' => $a->size,
                    'url' => $a->url,
                ]),
                'created_at' => $result->created_at,
            ],
        ], 201);
    }

    public function markRead(Request $request, Query $query)
    {
        if ($query->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Query not found.'], 404);
        }

        $query->update(['doctor_read_at' => now()]);

        $unreadCount = $query->unreadCountFor('doctor');

        QueryMessageRead::dispatch($query->id, 'doctor', $unreadCount);

        return response()->json(['unread_count' => $unreadCount]);
    }

    private function handleAttachments(QueryMessage $message, array $files): void
    {
        foreach ($files as $file) {
            $path = $file->store('query-attachments', 'public');
            $message->attachments()->create([
                'path' => $path,
                'original_name' => $file->getClientOriginalName(),
                'mime_type' => $file->getMimeType(),
                'size' => $file->getSize(),
            ]);
        }
    }
}
