<?php

namespace App\Domain\Shared\Services;

use App\Domain\Shared\Models\Quiz;
use App\Domain\Doctor\Models\User;
use Illuminate\Support\Facades\Cache;

class LeaderboardService
{
    /**
     * Get the ranked leaderboard for a specific quiz.
     */
    public function rank(Quiz $quiz, int $limit = 10)
    {
        $cacheKey = "quiz_{$quiz->id}_leaderboard";

        return Cache::remember($cacheKey, 30, function () use ($quiz, $limit) {
            $query = $quiz->attempts()
                ->where('status', 'submitted')
                ->whereHas('user', function ($q) {
                    $q->where('status', 'verified');
                })
                ->with('user:id,full_name,photo_path')
                ->orderByDesc('score');

            if ($quiz->tie_breaker === 'score_then_time') {
                $query->orderBy('duration_seconds');
            } else {
                $query->orderBy('submitted_at');
            }

            $attempts = $query->get();

            // Rank them
            $ranked = $attempts->map(function ($attempt, $index) {
                return [
                    'rank' => $index + 1,
                    'user_id' => $attempt->user_id,
                    'full_name' => $attempt->user->full_name,
                    'photo_url' => $attempt->user->photo_url,
                    'score' => $attempt->score,
                    'duration_seconds' => abs($attempt->duration_seconds),
                    'submitted_at' => $attempt->toArray()['submitted_at'] ?? null,
                    'is_podium' => $index < 3,
                ];
            });

            return $ranked->take($limit)->values();
        });
    }

    /**
     * Get the current user's rank.
     */
    public function myRank(Quiz $quiz, User $user)
    {
        if ($user->status !== 'verified') {
            return null;
        }

        $query = $quiz->attempts()
            ->where('status', 'submitted')
            ->whereHas('user', function ($q) {
                $q->where('status', 'verified');
            })
            ->orderByDesc('score');

        if ($quiz->tie_breaker === 'score_then_time') {
            $query->orderBy('duration_seconds');
        } else {
            $query->orderBy('submitted_at');
        }

        $attempts = $query->get();

        $myIndex = $attempts->search(function ($attempt) use ($user) {
            return $attempt->user_id === $user->id;
        });

        if ($myIndex === false) {
            return null;
        }

        $myAttempt = $attempts[$myIndex];

        return [
            'rank' => $myIndex + 1,
            'user_id' => $myAttempt->user_id,
            'full_name' => $myAttempt->user->full_name,
            'photo_url' => $myAttempt->user->photo_url,
            'score' => $myAttempt->score,
            'duration_seconds' => abs($myAttempt->duration_seconds),
            'submitted_at' => $myAttempt->toArray()['submitted_at'] ?? null,
            'is_podium' => $myIndex < 3,
        ];
    }
}
