<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\SystemLog;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;

class SystemLogController extends Controller
{
    public function index(Request $request)
    {
        $query = SystemLog::query();

        if ($request->has('category')) {
            $query->ofCategory($request->category);
        }

        $logs = $query->latest()->paginate($request->query('per_page', 4));

        $data = $logs->getCollection()->map(fn ($log) => [
            'id' => $log->id,
            'category' => $log->category,
            'color' => $log->color,
            'title' => $log->title,
            'description' => $log->description,
            'causer_name' => $log->causer_name,
            'metadata' => $log->metadata,
            'created_at' => $log->created_at->toISOString(),
            'time_ago' => $log->time_ago,
        ]);

        return response()->json([
            'data' => $data,
            'pagination' => [
                'page' => $logs->currentPage(),
                'per_page' => $logs->perPage(),
                'total' => $logs->total(),
                'last_page' => $logs->lastPage(),
                'has_next' => $logs->hasMorePages(),
                'has_previous' => $logs->currentPage() > 1,
            ],
        ]);
    }
}
