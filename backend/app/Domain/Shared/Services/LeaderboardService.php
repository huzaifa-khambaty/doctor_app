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
                ->with(['user' => function ($q) {
                    $q->select('id', 'full_name', 'photo_path', 'location', 'points', 'specialty_id')
                      ->with('specialty:id,name');
                }])
                ->orderByDesc('score');

            if ($quiz->tie_breaker === 'score_then_time') {
                $query->orderBy('duration_seconds');
            } else {
                $query->orderBy('submitted_at');
            }

            $attempts = $query->get();

            $ranked = $attempts->map(function ($attempt, $index) {
                $user = $attempt->user;
                $initials = collect(explode(' ', $user->full_name))
                    ->map(fn ($part) => strtoupper(mb_substr($part, 0, 1)))
                    ->take(2)
                    ->implode('');

                return [
                    'rank' => $index + 1,
                    'user_id' => $attempt->user_id,
                    'name' => $user->full_name,
                    'speciality' => $user->specialty->name ?? null,
                    'location' => $user->location,
                    'avatar' => $user->photo_url,
                    'initials' => $user->photo_url ? null : $initials,
                    'points' => $user->points,
                    'score' => $attempt->score,
                    'duration_seconds' => abs($attempt->duration_seconds),
                    'submitted_at' => $attempt->toArray()['submitted_at'] ?? null,
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
            ->with(['user' => function ($q) {
                $q->select('id', 'full_name', 'photo_path', 'location', 'points', 'specialty_id')
                  ->with('specialty:id,name');
            }])
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
        $nextAttempt = $attempts[$myIndex - 1] ?? null;
        $userModel = $myAttempt->user;

        $latestBadge = \App\Domain\Shared\Models\UserBadge::where('user_id', $user->id)
            ->with('badge')
            ->latest('awarded_at')
            ->first();

        $badgeUrl = null;
        if ($latestBadge && $latestBadge->badge && $latestBadge->badge->icon_path) {
            $badgeUrl = asset('storage/' . $latestBadge->badge->icon_path);
        }

        $initials = collect(explode(' ', $userModel->full_name))
            ->map(fn ($part) => strtoupper(mb_substr($part, 0, 1)))
            ->take(2)
            ->implode('');

        return [
            'rank' => $myIndex + 1,
            'user_id' => $myAttempt->user_id,
            'name' => $userModel->full_name,
            'avatar' => $userModel->photo_url,
            'initials' => $userModel->photo_url ? null : $initials,
            'points' => $userModel->points,
            'next_rank_points' => $nextAttempt ? $userModel->points - $nextAttempt->user->points : 0,
            'badge_url' => $badgeUrl,
        ];
    }
}
