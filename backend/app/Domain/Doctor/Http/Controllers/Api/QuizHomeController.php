<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\Topic;
use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Doctor\Models\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class QuizHomeController extends Controller
{
    public function home(Request $request)
    {
        $user = $request->user();

        $currentStatus = $this->getCurrentStatus($user);
        $dailyChallenge = $this->getDailyChallenge($user);
        $topics = $this->getTopicsWithProgress($user);
        $leaderboard = $this->getLeaderboard();

        return response()->json([
            'current_status' => $currentStatus,
            'daily_challenge' => $dailyChallenge,
            'topics' => $topics,
            'leaderboard' => $leaderboard,
        ]);
    }

    public function topicQuizzes(Request $request, Topic $topic)
    {
        $user = $request->user();

        $quizzes = Quiz::where('topic_id', $topic->id)
            ->where('status', 'published')
            ->withCount('questions')
            ->get()
            ->map(function ($quiz) use ($user) {
                $completed = QuizAttempt::where('quiz_id', $quiz->id)
                    ->where('user_id', $user->id)
                    ->where('status', 'submitted')
                    ->exists();

                return [
                    'id' => $quiz->id,
                    'title' => $quiz->title,
                    'questions' => $quiz->questions_count,
                    'duration' => $quiz->time_limit_minutes,
                    'xp' => $quiz->questions_count * 100,
                    'completed' => $completed,
                ];
            });

        return response()->json([
            'topic' => [
                'id' => $topic->id,
                'name' => $topic->name,
                'icon' => $topic->icon ? asset('storage/' . $topic->icon) : null,
            ],
            'data' => $quizzes,
        ]);
    }

    protected function getCurrentStatus(User $user)
    {
        $rank = User::where('points', '>', $user->points)->count() + 1;

        $streak = $this->calculateStreak($user);

        return [
            'rank' => $rank,
            'streak' => $streak,
            'xp' => $user->points ?? 0,
        ];
    }

    protected function calculateStreak(User $user): int
    {
        $publishedQuizzes = Quiz::where('status', 'published')
            ->orWhere('status', 'closed')
            ->orderByDesc('opens_at')
            ->pluck('id');

        $submittedQuizIds = QuizAttempt::where('user_id', $user->id)
            ->where('status', 'submitted')
            ->whereIn('quiz_id', $publishedQuizzes)
            ->pluck('quiz_id')
            ->toArray();

        $streak = 0;
        foreach ($publishedQuizzes as $quizId) {
            if (in_array($quizId, $submittedQuizIds)) {
                $streak++;
            } else {
                break;
            }
        }

        return $streak;
    }

    protected function getDailyChallenge(User $user)
    {
        $quiz = Quiz::where('status', 'published')
            ->where(function ($q) {
                $q->whereNull('opens_at')
                  ->orWhere('opens_at', '<=', now());
            })
            ->withCount('questions')
            ->orderByDesc('created_at')
            ->first();

        if (!$quiz) {
            return null;
        }

        $remainingSeconds = null;
        $expiresAt = null;
        if ($quiz->closes_at && $quiz->closes_at->isFuture()) {
            $remainingSeconds = (int) now()->diffInSeconds($quiz->closes_at);
            $expiresAt = $quiz->closes_at->toISOString();
        }

        return [
            'id' => $quiz->id,
            'title' => $quiz->title,
            'description' => $quiz->description,
            'xp' => $quiz->questions_count * 100,
            'remaining_seconds' => $remainingSeconds,
            'expires_at' => $expiresAt,
            'banner' => $quiz->banner ? asset('storage/' . $quiz->banner) : null,
            'quiz_id' => $quiz->id,
        ];
    }

    protected function getTopicsWithProgress(User $user)
    {
        $topics = Topic::where('is_active', true)->get();

        $quizCounts = Quiz::where('quizzes.status', 'published')
            ->orWhere('quizzes.status', 'closed')
            ->select('topic_id', DB::raw('COUNT(*) as total'))
            ->groupBy('topic_id')
            ->pluck('total', 'topic_id');

        $userProgress = QuizAttempt::where('quiz_attempts.user_id', $user->id)
            ->where('quiz_attempts.status', 'submitted')
            ->join('quizzes', 'quiz_attempts.quiz_id', '=', 'quizzes.id')
            ->select('quizzes.topic_id', DB::raw('COUNT(*) as completed'))
            ->groupBy('quizzes.topic_id')
            ->pluck('completed', 'topic_id');

        return $topics->map(function ($topic) use ($quizCounts, $userProgress) {
            $total = $quizCounts->get($topic->id, 0);
            $completed = $userProgress->get($topic->id, 0);

            return [
                'id' => $topic->id,
                'name' => $topic->name,
                'icon' => $topic->icon ? asset('storage/' . $topic->icon) : null,
                'total_quizzes' => $total,
                'progress' => $total > 0 ? round(($completed / $total) * 100) : 0,
            ];
        })->filter(fn ($topic) => $topic['total_quizzes'] > 1)->values();
    }

    protected function getLeaderboard()
    {
        return User::where('status', 'verified')
            ->orderByDesc('points')
            ->limit(10)
            ->get()
            ->map(function ($user, $index) {
                return [
                    'rank' => $index + 1,
                    'doctor_name' => $user->full_name,
                    'points' => $user->points ?? 0,
                ];
            });
    }
}
