<?php

namespace App\Domain\Shared\Services;

use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\Badge;
use App\Domain\Shared\Models\UserBadge;
use App\Domain\Doctor\Models\User;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;

class BadgeAwardService
{
    /**
     * Evaluate all active badges for a submitted attempt.
     */
    public function evaluate(QuizAttempt $attempt)
    {
        if ($attempt->status !== 'submitted') {
            return;
        }

        $badges = Badge::where('is_active', true)
            ->whereNotNull('criteria_type')
            ->get();

        foreach ($badges as $badge) {
            $this->evaluateBadge($badge, $attempt);
        }
    }

    /**
     * Evaluate a single badge against an attempt.
     */
    protected function evaluateBadge(Badge $badge, QuizAttempt $attempt)
    {
        $earned = match($badge->criteria_type) {
            'quiz_completed' => $this->checkQuizCompleted($attempt, $badge->criteria_value),
            'perfect_score' => $this->checkPerfectScore($attempt),
            'quiz_streak' => $this->checkQuizStreak($attempt, $badge->criteria_value),
            'fast_learner' => $this->checkFastLearner($attempt),
            'expert' => $this->checkExpert($attempt->user),
            default => false,
        };

        if ($earned) {
            $this->awardBadge($attempt->user_id, $badge->code);
        }
    }

    /**
     * Evaluate top_3 badge separately (called from leaderboard recalculation).
     */
    public function evaluateTop3(Quiz $quiz)
    {
        $badge = Badge::where('code', 'top_3')->where('is_active', true)->first();
        if (!$badge) {
            return;
        }

        $leaderboardService = new LeaderboardService();
        $ranked = $leaderboardService->rank($quiz, 3);

        foreach ($ranked as $r) {
            if ($r['is_podium']) {
                $this->awardBadge($r['user_id'], $badge->code);
            }
        }
    }

    /**
     * Award a badge to a user (idempotent).
     */
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

    // ─── Criteria Check Methods ───────────────────────────────────────

    /**
     * quiz_completed: user has submitted >= $value quizzes.
     */
    protected function checkQuizCompleted(QuizAttempt $attempt, int $value): bool
    {
        $submittedCount = QuizAttempt::where('user_id', $attempt->user_id)
            ->where('status', 'submitted')
            ->count();

        return $submittedCount >= $value;
    }

    /**
     * perfect_score: score equals total questions.
     */
    protected function checkPerfectScore(QuizAttempt $attempt): bool
    {
        $totalQuestions = $attempt->quiz->questions()->count();

        return $totalQuestions > 0 && $attempt->score === $totalQuestions;
    }

    /**
     * quiz_streak: participated in $value consecutive published/closed quizzes.
     */
    protected function checkQuizStreak(QuizAttempt $attempt, int $value): bool
    {
        $lastQuizzes = Quiz::whereIn('status', ['published', 'closed'])
            ->whereNotNull('opens_at')
            ->where('opens_at', '<=', now())
            ->orderByDesc('opens_at')
            ->limit($value)
            ->get();

        if ($lastQuizzes->count() < $value) {
            return false;
        }

        $participatedCount = 0;

        foreach ($lastQuizzes as $quiz) {
            $hasAttempted = QuizAttempt::where('quiz_id', $quiz->id)
                ->where('user_id', $attempt->user_id)
                ->where('status', 'submitted')
                ->exists();

            if ($hasAttempted) {
                $participatedCount++;
            } else {
                break;
            }
        }

        return $participatedCount === $value;
    }

    /**
     * fast_learner: score >= 80% AND finished within quiz time limit.
     */
    protected function checkFastLearner(QuizAttempt $attempt): bool
    {
        $totalQuestions = $attempt->quiz->questions()->count();
        if ($totalQuestions === 0) {
            return false;
        }

        $scorePercentage = ($attempt->score / $totalQuestions) * 100;
        $withinTime = $attempt->quiz->time_limit_minutes
            && $attempt->duration_seconds <= ($attempt->quiz->time_limit_minutes * 60);

        return $scorePercentage >= 80 && $withinTime;
    }

    /**
     * expert: average score >= 90% over >= 20 submitted quizzes.
     */
    protected function checkExpert(User $user): bool
    {
        $stats = QuizAttempt::where('user_id', $user->id)
            ->where('status', 'submitted')
            ->selectRaw('COUNT(*) as total, AVG(score) as avg_score')
            ->first();

        if ($stats->total < 20) {
            return false;
        }

        // Get average score as percentage across all quizzes
        $totalPossible = DB::table('quiz_attempt_answers')
            ->join('quiz_questions', 'quiz_attempt_answers.quiz_question_id', '=', 'quiz_questions.id')
            ->join('quiz_attempts', 'quiz_attempt_answers.quiz_attempt_id', '=', 'quiz_attempts.id')
            ->where('quiz_attempts.user_id', $user->id)
            ->where('quiz_attempts.status', 'submitted')
            ->count();

        $totalCorrect = DB::table('quiz_attempt_answers')
            ->join('quiz_attempts', 'quiz_attempt_answers.quiz_attempt_id', '=', 'quiz_attempts.id')
            ->where('quiz_attempts.user_id', $user->id)
            ->where('quiz_attempts.status', 'submitted')
            ->where('quiz_attempt_answers.is_correct', true)
            ->count();

        if ($totalPossible === 0) {
            return false;
        }

        $avgPercentage = ($totalCorrect / $totalPossible) * 100;

        return $avgPercentage >= 90;
    }
}
