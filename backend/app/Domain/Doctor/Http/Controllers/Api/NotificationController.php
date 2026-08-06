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

        $notifications = Notification::where('status', 'published')
            ->orderBy('sent_at', 'desc')
            ->paginate($request->query('per_page', 15));

        $notifications->getCollection()->transform(function ($notification) use ($user) {
            return [
                'id' => $notification->id,
                'title' => $notification->title,
                'message' => $notification->message,
                'sent_at' => $notification->sent_at?->toISOString(),
                'is_opened' => $notification->opens()->where('user_id', $user->id)->exists(),
            ];
        });

        return response()->json($notifications);
    }
}
