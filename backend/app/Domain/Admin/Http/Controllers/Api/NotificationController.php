<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Admin\Http\Requests\StoreNotificationRequest;
use App\Domain\Admin\Http\Requests\UpdateNotificationRequest;
use App\Domain\Shared\Models\Notification;
use App\Domain\Shared\Models\SystemLog;
use App\Domain\Shared\Services\FcmService;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Log;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        Gate::authorize('notifications.view');

        $status = $request->query('status', 'all');
        $perPage = $request->query('per_page', 10);

        // Scheduled notifications (no pagination)
        $scheduledQuery = Notification::where('status', 'scheduled');

        // History (published notifications, paginated)
        $historyQuery = Notification::where('status', 'published')->with('creator');

        // Apply status filter
        if ($status !== 'all') {
            $scheduledQuery->where('status', 'scheduled');
            $historyQuery->where('status', 'scheduled');
        }

        $scheduled = $scheduledQuery->orderBy('schedule_at', 'asc')->get();
        $history = $historyQuery->orderBy('sent_at', 'desc')->paginate($perPage);

        // Format scheduled notifications
        $scheduledNotifications = $scheduled->map(fn ($n) => [
            'id' => $n->id,
            'title' => $n->title,
            'target_audience' => $this->formatAudience($n->audience_segment),
            'status' => $n->status,
            'scheduled_at' => $n->schedule_at->toISOString(),
            'can_edit' => true,
            'can_cancel' => true,
        ]);

        // Format history
        $historyFormatted = $history->getCollection()->map(fn ($n) => [
            'id' => $n->id,
            'title' => $n->title,
            'type' => 'Push Notification',
            'target_audience' => $this->formatAudience($n->audience_segment),
            'sent_at' => $n->sent_at?->toISOString(),
            'status' => 'delivered',
            'recipient_count' => $n->estimated_recipients,
            'opened_count' => $n->opened_count,
            'open_rate' => $n->open_rate,
            'created_by' => $n->creator->name ?? 'Unknown',
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Notifications retrieved successfully.',
            'data' => [
                'summary' => [
                    'pending_count' => $scheduled->count(),
                ],
                'scheduled_notifications' => $scheduledNotifications,
                'history' => $historyFormatted,
                'pagination' => [
                    'current_page' => $history->currentPage(),
                    'per_page' => $history->perPage(),
                    'total' => $history->total(),
                    'last_page' => $history->lastPage(),
                ],
            ],
        ]);
    }

    private function formatAudience(string $segment): string
    {
        return match ($segment) {
            'all_users' => 'All Users',
            'verified' => 'Verified Clinicians',
            'pending' => 'Pending Verification',
            default => 'All Users',
        };
    }

    public function store(StoreNotificationRequest $request)
    {
        Gate::authorize('notifications.create');

        $validated = $request->validated();
        $validated['created_by'] = $request->user()->id;

        $validated['estimated_recipients'] = Notification::getEstimatedRecipients(
            $validated['audience_segment']
        );

        if ($validated['status'] === 'published' && !empty($validated['schedule_at'])) {
            $validated['status'] = 'scheduled';
        }

        $notification = Notification::create($validated);

        SystemLog::log(
            'notification',
            'Notification Created',
            '"' . $notification->title . '" was created.',
            $request->user()->name ?? null,
            ['notification_id' => $notification->id, 'status' => $notification->status]
        );

        $sendResult = null;
        if ($notification->status === 'published' && !$notification->schedule_at) {
            $sendResult = $this->sendNotification($notification);
        }

        return response()->json([
            'success' => true,
            'message' => 'Notification created successfully.',
            'data' => [
                'id' => $notification->id,
                'title' => $notification->title,
                'message' => $notification->message,
                'audience_segment' => $notification->audience_segment,
                'estimated_recipients' => $notification->estimated_recipients,
                'status' => $notification->status,
                'schedule_at' => $notification->schedule_at,
                'sent_at' => $notification->sent_at,
                'success_count' => $sendResult['success_count'] ?? null,
                'fail_count' => $sendResult['fail_count'] ?? null,
                'created_by' => [
                    'id' => $request->user()->id,
                    'name' => $request->user()->name,
                ],
                'created_at' => $notification->created_at->toISOString(),
            ],
        ], 201);
    }

    public function show(Notification $notification)
    {
        Gate::authorize('notifications.view');

        $notification->load('creator');

        return response()->json([
            'data' => [
                'id' => $notification->id,
                'title' => $notification->title,
                'message' => $notification->message,
                'audience_segment' => $notification->audience_segment,
                'status' => $notification->status,
                'schedule_at' => $notification->schedule_at,
                'sent_at' => $notification->sent_at,
                'estimated_recipients' => $notification->estimated_recipients,
                'created_by' => [
                    'id' => $notification->creator->id,
                    'name' => $notification->creator->name,
                ],
                'created_at' => $notification->created_at->toISOString(),
            ],
        ]);
    }

    public function update(UpdateNotificationRequest $request, Notification $notification)
    {
        Gate::authorize('notifications.create');

        if ($notification->status === 'published') {
            return response()->json([
                'success' => false,
                'message' => 'Cannot edit a notification that has already been sent.',
            ], 422);
        }

        $validated = $request->validated();

        // Auto-set status based on schedule_at
        if (isset($validated['schedule_at']) && !empty($validated['schedule_at'])) {
            $validated['status'] = 'scheduled';
        }

        // Recalculate estimated recipients if audience changed
        if (isset($validated['audience_segment'])) {
            $validated['estimated_recipients'] = Notification::getEstimatedRecipients(
                $validated['audience_segment']
            );
        }

        $notification->update($validated);

        SystemLog::log(
            'notification',
            'Notification Updated',
            '"' . $notification->title . '" was updated.',
            $request->user()->name ?? null,
            ['notification_id' => $notification->id, 'status' => $notification->status]
        );

        $notification->load('creator');

        return response()->json([
            'success' => true,
            'message' => 'Notification updated successfully.',
            'data' => [
                'id' => $notification->id,
                'title' => $notification->title,
                'message' => $notification->message,
                'audience_segment' => $notification->audience_segment,
                'estimated_recipients' => $notification->estimated_recipients,
                'status' => $notification->status,
                'schedule_at' => $notification->schedule_at,
                'created_by' => [
                    'id' => $notification->creator->id,
                    'name' => $notification->creator->name,
                ],
                'created_at' => $notification->created_at->toISOString(),
            ],
        ]);
    }

    public function send(Notification $notification)
    {
        Gate::authorize('notifications.create');

        if ($notification->status !== 'scheduled') {
            return response()->json([
                'success' => false,
                'message' => 'Only scheduled notifications can be sent.',
            ], 422);
        }

        $sendResult = $this->sendNotification($notification);

        return response()->json([
            'success' => true,
            'message' => 'Notification sent successfully.',
            'data' => [
                'success_count' => $sendResult['success_count'],
                'fail_count' => $sendResult['fail_count'],
            ],
        ]);
    }

    public function cancel(Notification $notification)
    {
        Gate::authorize('notifications.create');

        if ($notification->status !== 'scheduled') {
            return response()->json([
                'success' => false,
                'message' => 'Only scheduled notifications can be cancelled.',
            ], 422);
        }

        $notification->update(['status' => 'draft']);

        return response()->json([
            'success' => true,
            'message' => 'Notification cancelled and saved as draft.',
        ]);
    }

    public function destroy(Notification $notification)
    {
        Gate::authorize('notifications.delete');

        $notification->delete();

        return response()->json([
            'success' => true,
            'message' => 'Notification deleted successfully.',
        ]);
    }

    private function sendNotification(Notification $notification): array
    {
        $fcmService = app(FcmService::class);

        $users = $this->getTargetUsers($notification->audience_segment)
            ->whereNotNull('fcm_token')
            ->get();

        Log::info('Notification Send Started', [
            'notification_id' => $notification->id,
            'audience' => $notification->audience_segment,
            'users_with_token' => $users->count(),
        ]);

        $successCount = 0;
        $failCount = 0;
        $errors = [];

        foreach ($users as $user) {
            $result = $fcmService->sendToDevice(
                $user->fcm_token,
                $notification->title,
                $notification->message,
                ['notification_id' => (string) $notification->id]
            );

            if ($result['success']) {
                $successCount++;
            } else {
                $failCount++;
                $errors[] = [
                    'user_id' => $user->id,
                    'error' => $result['message'],
                ];
            }
        }

        $notification->update([
            'status' => 'published',
            'sent_at' => now(),
        ]);

        SystemLog::log(
            'notification',
            'Notification Sent',
            '"' . $notification->title . '" — ' . $successCount . ' sent, ' . $failCount . ' failed.',
            null,
            [
                'notification_id' => $notification->id,
                'success_count' => $successCount,
                'fail_count' => $failCount,
                'errors' => $errors,
            ]
        );

        return [
            'success_count' => $successCount,
            'fail_count' => $failCount,
        ];
    }

    private function getTargetUsers(string $segment)
    {
        $query = \App\Domain\Doctor\Models\User::query();

        switch ($segment) {
            case 'verified':
                return $query->where('status', 'verified');
            case 'pending':
                return $query->where('status', 'pending');
            case 'all_users':
            default:
                return $query;
        }
    }
}
