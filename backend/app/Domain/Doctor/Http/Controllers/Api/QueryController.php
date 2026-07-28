<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Domain\Shared\Models\Query;
use App\Domain\Shared\Models\QueryCategory;
use App\Domain\Doctor\Http\Requests\StoreQueryRequest;
use Illuminate\Http\Request;

class QueryController extends Controller
{
    public function categories()
    {
        $categories = QueryCategory::select('id', 'name', 'slug')->orderBy('name')->get();
        return response()->json($categories);
    }

    public function store(StoreQueryRequest $request)
    {
        $query = Query::create([
            'user_id' => $request->user()->id,
            'query_category_id' => $request->category_id,
            'subject' => $request->subject,
            'message' => $request->message,
            'status' => 'pending',
        ]);

        $query->load('category:id,name,slug');

        QueryAdd::dispatch($query);

        return response()->json([
            'message' => 'Query submitted successfully.',
            'data' => [
                'id' => $query->id,
                'category' => [
                    'id' => $query->category->id,
                    'name' => $query->category->name,
                    'slug' => $query->category->slug,
                ],
                'subject' => $query->subject,
                'message' => $query->message,
                'status' => $query->status,
                'created_at' => $query->created_at,
            ],
        ], 201);
    }

    public function myQueries(Request $request)
    {
        $queries = Query::where('user_id', $request->user()->id)
            ->with('category:id,name,slug')
            ->orderByDesc('created_at')
            ->paginate($request->query('per_page', 15));

        $queries->getCollection()->transform(function ($query) {
            return [
                'id' => $query->id,
                'category' => [
                    'id' => $query->category->id,
                    'name' => $query->category->name,
                    'slug' => $query->category->slug,
                ],
                'subject' => $query->subject,
                'message' => $query->message,
                'status' => $query->status,
                'admin_response' => $query->admin_response,
                'responded_at' => $query->responded_at,
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

        $query->load('category:id,name,slug', 'responder:id,name');

        return response()->json([
            'id' => $query->id,
            'category' => [
                'id' => $query->category->id,
                'name' => $query->category->name,
                'slug' => $query->category->slug,
            ],
            'subject' => $query->subject,
            'message' => $query->message,
            'status' => $query->status,
            'admin_response' => $query->admin_response,
            'responded_at' => $query->responded_at,
            'responder' => $query->responder ? [
                'id' => $query->responder->id,
                'name' => $query->responder->name,
            ] : null,
            'created_at' => $query->created_at,
        ]);
    }
}
