<?php

namespace App\Domain\Shared\Services;

use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\Badge;
use App\Domain\Shared\Models\UserBadge;
use Illuminate\Support\Facades\Log;

class BadgeAwardService
{
    /**
     * Evaluate badges for a submitted attempt.
     */
    public function evaluate(QuizAttempt $attempt)
    {
        if ($attempt->status !== 'submitted') {
            return;
        }

        $user = $attempt->user;
        $quiz = $attempt->quiz;

        // 1. "first_quiz"
        $this->evaluateFirstQuiz($attempt);

        // 2. "perfect_score"
        $this->evaluatePerfectScore($attempt);

        // 3. "streak_5"
        $this->evaluateStreak($attempt);
    }

    protected function awardBadge(int $userId, string $badgeCode)
    {
        $badge = Badge::where('code', $badgeCode)->first();

        if (!$badge) {
            Log::warning("Badge {$badgeCode} not found in DB.");
            return;
        }

        UserBadge::firstOrCreate([
            'user_id' => $userId,
            'badge_id' => $badge->id,
        ], [
            'awarded_at' => now(),
        ]);
    }

    protected function evaluateFirstQuiz(QuizAttempt $attempt)
    {
        $submittedCount = QuizAttempt::where('user_id', $attempt->user_id)
            ->where('status', 'submitted')
            ->count();

        if ($submittedCount === 1) {
            $this->awardBadge($attempt->user_id, 'first_quiz');
        }
    }

    protected function evaluatePerfectScore(QuizAttempt $attempt)
    {
        $totalQuestions = $attempt->quiz->questions()->count();

        if ($totalQuestions > 0 && $attempt->score === $totalQuestions) {
            $this->awardBadge($attempt->user_id, 'perfect_score');
        }
    }

    protected function evaluateStreak(QuizAttempt $attempt)
    {
        // "streak_5" — participated in 5 consecutive quizzes
        // Quizzes ordered by opens_at, no gap in participation for the last 5 published+closed quizzes.
        
        $last5Quizzes = Quiz::whereIn('status', ['published', 'closed'])
            ->whereNotNull('opens_at')
            ->where('opens_at', '<=', now())
            ->orderByDesc('opens_at')
            ->limit(5)
            ->get();

        if ($last5Quizzes->count() < 5) {
            return;
        }

        $participatedCount = 0;

        foreach ($last5Quizzes as $q) {
            $hasAttempted = QuizAttempt::where('quiz_id', $q->id)
                ->where('user_id', $attempt->user_id)
                ->where('status', 'submitted')
                ->exists();

            if ($hasAttempted) {
                $participatedCount++;
            } else {
                break; // Break streak
            }
        }

        if ($participatedCount === 5) {
            $this->awardBadge($attempt->user_id, 'streak_5');
        }
    }

    public function evaluateTop3(Quiz $quiz)
    {
        // Find the top 3 submitted attempts
        $leaderboardService = new LeaderboardService();
        $ranked = $leaderboardService->rank($quiz, 3);

        foreach ($ranked as $r) {
            if ($r['is_podium']) {
                $this->awardBadge($r['user_id'], 'top_3');
            }
        }
    }
}
