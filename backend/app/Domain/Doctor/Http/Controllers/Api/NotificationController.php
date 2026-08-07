<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\Notification;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class NotificationController extends Controller
{
    public function markOpened(Request $request, Notification $notification)
    {
        $user = $request->user();

        $notification->markOpenedBy($user);

        return response()->json([
            'success' => true,
            'message' => 'Notification marked as opened.',
        ]);
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $perPage = $request->query('per_page', 15);

        $paginator = Notification::where('status', 'published')
            ->orderBy('sent_at', 'desc')
            ->paginate($perPage);

        $notifications = $paginator->getCollection()->map(function ($notification) use ($user) {
            return [
                'id' => $notification->id,
                'title' => $notification->title,
                'message' => $notification->message,
                'sent_at' => $notification->sent_at?->toISOString(),
                'is_opened' => $notification->opens()->where('user_id', $user->id)->exists(),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $notifications,
            'pagination' => [
                'page' => $paginator->currentPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
                'last_page' => $paginator->lastPage(),
                'has_next' => $paginator->hasMorePages(),
                'has_previous' => $paginator->currentPage() > 1,
            ],
        ]);
    }
}
