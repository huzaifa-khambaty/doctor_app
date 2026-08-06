<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Domain\Shared\Services\FcmService;

class TestFcmSend extends Command
{
    protected $signature = 'notifications:test-send {token?}';

    protected $description = 'Test FCM send to a specific token (or user ID 11)';

    public function handle(FcmService $fcmService)
    {
        $token = $this->argument('token');

        if (!$token) {
            $user = \App\Domain\Doctor\Models\User::find(11);
            if (!$user || !$user->fcm_token) {
                $this->error('User 11 has no fcm_token.');
                return;
            }
            $token = $user->fcm_token;
            $this->info('Using token from User 11: ' . substr($token, 0, 30) . '...');
        }

        $this->info('Sending test notification...');

        $result = $fcmService->sendToDevice(
            $token,
            'Test Notification',
            'This is a test from RespiLink Admin.',
            ['test' => 'true']
        );

        if ($result['success']) {
            $this->info('SUCCESS: Notification sent!');
        } else {
            $this->error('FAILED: ' . $result['message']);
        }

        $this->newLine();
        $this->info('Check storage/logs/laravel.log for details.');
    }
}
