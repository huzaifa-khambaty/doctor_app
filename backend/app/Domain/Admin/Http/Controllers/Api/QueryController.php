<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Domain\Shared\Models\Query;
use App\Domain\Shared\Models\QueryCategory;
use App\Domain\Shared\Models\QueryMessage;
use App\Domain\Shared\Http\Requests\SendQueryMessageRequest;
use App\Events\QueryMessageSent;
use App\Events\QueryMessageRead;
use App\Events\QueryStatusChanged;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class QueryController extends Controller
{
    public function index(Request $request)
    {
        $query = Query::with('category:id,name,slug', 'user:id,full_name,email')
            ->withCount('messages')
            ->with('latestMessage');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('category_id')) {
            $query->where('query_category_id', $request->category_id);
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('subject', 'like', "%{$search}%")
                  ->orWhereHas('user', function ($q2) use ($search) {
                      $q2->where('full_name', 'like', "%{$search}%");
                  });
            });
        }

        $queries = $query->orderByDesc('last_message_at')
            ->paginate($request->query('per_page', 15));

        $queries->getCollection()->transform(function ($query) {
            return [
                'id' => $query->id,
                'user' => [
                    'id' => $query->user->id,
                    'full_name' => $query->user->full_name,
                    'email' => $query->user->email,
                ],
                'category' => [
                    'id' => $query->category->id,
                    'name' => $query->category->name,
                    'slug' => $query->category->slug,
                ],
                'subject' => $query->subject,
                'status' => $query->status,
                'messages_count' => $query->messages_count,
                'unread_count' => $query->unreadCountFor('admin'),
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

    public function show(Query $query)
    {
        $query->load('category:id,name,slug', 'user:id,full_name,email');
        $query->loadCount('messages');

        return response()->json([
            'id' => $query->id,
            'user' => [
                'id' => $query->user->id,
                'full_name' => $query->user->full_name,
                'email' => $query->user->email,
            ],
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
        $result = DB::transaction(function () use ($request, $query) {
            $message = QueryMessage::create([
                'query_id' => $query->id,
                'sender_type' => 'admin',
                'sender_id' => $request->user()->id,
                'message' => $request->message,
            ]);

            if ($request->hasFile('attachments')) {
                $this->handleAttachments($message, $request->file('attachments'));
            }

            $query->update([
                'last_message_at' => now(),
                'admin_read_at' => now(),
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

    public function updateStatus(Request $request, Query $query)
    {
        $request->validate([
            'status' => 'required|in:open,in_progress,resolved,closed',
        ]);

        $query->update(['status' => $request->status]);

        QueryStatusChanged::dispatch($query->id, $request->status, $request->user()->id);

        return response()->json([
            'message' => 'Status updated.',
            'data' => [
                'id' => $query->id,
                'status' => $query->status,
            ],
        ]);
    }

    public function markRead(Request $request, Query $query)
    {
        $query->update(['admin_read_at' => now()]);

        $unreadCount = $query->unreadCountFor('admin');

        QueryMessageRead::dispatch($query->id, 'admin', $unreadCount);

        return response()->json(['unread_count' => $unreadCount]);
    }

    // Category CRUD
    public function categories()
    {
        $categories = QueryCategory::select('id', 'name', 'slug')->orderBy('name')->get();
        return response()->json($categories);
    }

    public function storeCategory(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255|unique:query_categories,name',
            'slug' => 'required|string|max:255|unique:query_categories,slug',
        ]);

        $category = QueryCategory::create([
            'name' => $request->name,
            'slug' => $request->slug,
        ]);

        return response()->json([
            'message' => 'Category created successfully.',
            'data' => $category,
        ], 201);
    }

    public function updateCategory(Request $request, QueryCategory $category)
    {
        $request->validate([
            'name' => 'sometimes|required|string|max:255|unique:query_categories,name,' . $category->id,
            'slug' => 'sometimes|required|string|max:255|unique:query_categories,slug,' . $category->id,
        ]);

        $category->update($request->only(['name', 'slug']));

        return response()->json([
            'message' => 'Category updated successfully.',
            'data' => $category,
        ]);
    }

    public function deleteCategory(QueryCategory $category)
    {
        if ($category->queries()->exists()) {
            return response()->json([
                'message' => 'Cannot delete category with existing queries.',
            ], 422);
        }

        $category->delete();

        return response()->json(['message' => 'Category deleted successfully.']);
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
