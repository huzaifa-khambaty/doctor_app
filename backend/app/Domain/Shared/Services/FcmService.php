<?php

namespace App\Domain\Shared\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

class FcmService
{
    private string $projectId;
    private string $serviceAccountPath;

    public function __construct()
    {
        $this->projectId = config('services.firebase.project_id');
        $this->serviceAccountPath = config('services.firebase.credentials');
    }

    public function sendToDevice(string $fcmToken, string $title, string $body, array $data = []): array
    {
        try {
            $accessToken = $this->getAccessToken();

            $payload = [
                'message' => [
                    'token' => $fcmToken,
                    'notification' => [
                        'title' => $title,
                        'body' => $body,
                    ],
                    'data' => array_map('strval', $data),
                    'android' => [
                        'priority' => 'high',
                    ],
                    'apns' => [
                        'headers' => [
                            'apns-priority' => '10',
                        ],
                    ],
                ],
            ];

            Log::info('FCM Sending', [
                'token' => substr($fcmToken, 0, 30) . '...',
                'title' => $title,
            ]);

            $response = Http::withToken($accessToken)
                ->post("https://fcm.googleapis.com/v1/projects/{$this->projectId}/messages:send", $payload);

            $responseBody = $response->json();

            if ($response->successful()) {
                Log::info('FCM Success', ['response' => $responseBody]);
                return ['success' => true, 'message' => 'Sent successfully', 'response' => $responseBody];
            } else {
                Log::error('FCM Failed', ['status' => $response->status(), 'response' => $responseBody]);
                return ['success' => false, 'message' => $responseBody['error']['message'] ?? 'Unknown error', 'response' => $responseBody];
            }
        } catch (\Exception $e) {
            Log::error('FCM Exception', ['error' => $e->getMessage()]);
            return ['success' => false, 'message' => $e->getMessage(), 'response' => null];
        }
    }

    public function sendToMultiple(array $tokens, string $title, string $body, array $data = []): array
    {
        $results = [];

        foreach ($tokens as $token) {
            $results[$token] = $this->sendToDevice($token, $title, $body, $data);
        }

        return $results;
    }

    private function getAccessToken(): string
    {
        $cacheKey = 'fcm_access_token';

        return Cache::remember($cacheKey, 3500, function () {
            $serviceAccount = json_decode(file_get_contents($this->serviceAccountPath), true);

            $now = time();
            $jwtHeader = base64_encode(json_encode(['alg' => 'RS256', 'typ' => 'JWT']));
            $jwtPayload = base64_encode(json_encode([
                'iss' => $serviceAccount['client_email'],
                'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
                'aud' => 'https://oauth2.googleapis.com/token',
                'iat' => $now,
                'exp' => $now + 3600,
            ]));

            $signatureInput = "$jwtHeader.$jwtPayload";
            openssl_sign($signatureInput, $signature, $serviceAccount['private_key'], 'SHA256');
            $jwtSignature = base64_encode($signature);

            $jwt = "$jwtHeader.$jwtPayload.$jwtSignature";

            $response = Http::asForm()->post('https://oauth2.googleapis.com/token', [
                'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
                'assertion' => $jwt,
            ]);

            $token = $response->json('access_token');

            if (!$token) {
                Log::error('FCM Token Exchange Failed', ['response' => $response->json()]);
                throw new \Exception('Failed to get FCM access token');
            }

            return $token;
        });
    }
}
