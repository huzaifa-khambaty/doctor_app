<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Domain\Shared\Models\Notification;
use App\Domain\Shared\Services\FcmService;
use App\Domain\Shared\Models\SystemLog;
use Illuminate\Support\Facades\Log;

class SendScheduledNotifications extends Command
{
    protected $signature = 'notifications:send-scheduled';

    protected $description = 'Send scheduled notifications whose time has arrived.';

    public function handle()
    {
        $notifications = Notification::pendingSchedule()->get();

        if ($notifications->isEmpty()) {
            $this->info('No scheduled notifications to send.');
            return;
        }

        $fcmService = app(FcmService::class);

        foreach ($notifications as $notification) {
            try {
                $users = $this->getTargetUsers($notification->audience_segment)
                    ->whereNotNull('fcm_token')
                    ->get();

                $successCount = 0;
                $failCount = 0;

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
                    }
                }

                $notification->update([
                    'status' => 'published',
                    'sent_at' => now(),
                ]);

                SystemLog::log(
                    'notification',
                    'Scheduled Notification Sent',
                    '"' . $notification->title . '" — ' . $successCount . ' sent, ' . $failCount . ' failed.',
                    null,
                    [
                        'notification_id' => $notification->id,
                        'success_count' => $successCount,
                        'fail_count' => $failCount,
                    ]
                );

                $this->info("Sent notification ID: {$notification->id} — {$notification->title} ({$successCount} sent, {$failCount} failed)");
            } catch (\Exception $e) {
                Log::error("Failed to send notification {$notification->id}: " . $e->getMessage());
                $this->error("Failed to send notification {$notification->id}");
            }
        }

        $this->info('Finished sending scheduled notifications.');
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
