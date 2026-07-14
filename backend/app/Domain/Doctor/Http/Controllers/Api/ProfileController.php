<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\Quiz;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\DB;

class ProfileController extends Controller
{
    public function verificationStatus(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'status' => $user->status,
            'verified_at' => $user->verified_at,
            'rejection_reason' => $user->status === 'rejected' ? $user->rejection_reason : null,
        ]);
    }

    public function requestDeletion(Request $request)
    {
        $user = $request->user();

        if ($user->accountDeletionRequests()->where('status', 'pending')->exists()) {
            return response()->json(['message' => 'You already have a pending account deletion request.'], 422);
        }

        $request->validate(['reason' => 'nullable|string']);

        $user->accountDeletionRequests()->create([
            'reason' => $request->reason,
            'status' => 'pending',
            'requested_at' => now(),
        ]);

        return response()->json(['message' => 'Account deletion requested successfully.'], 201);
    }

    public function statistics(Request $request)
    {
        $user = $request->user();

        $totalQuizzesAttempted = $user->quizAttempts()->where('status', 'submitted')->count();
        
        $avgScore = $user->quizAttempts()
            ->where('status', 'submitted')
            ->avg('score');

        $totalPoints = $user->points ?? 0;
        
        $totalBadges = $user->badges()->count();

        $bestScore = $user->quizAttempts()
            ->where('status', 'submitted')
            ->max('score');

        $recentAttempts = $user->quizAttempts()
            ->where('status', 'submitted')
            ->with('quiz:id,title,topic')
            ->latest('submitted_at')
            ->take(5)
            ->get(['id', 'quiz_id', 'score', 'duration_seconds', 'submitted_at']);

        return response()->json([
            'total_quizzes_attempted' => $totalQuizzesAttempted,
            'average_score' => round($avgScore ?? 0, 2),
            'best_score' => $bestScore ?? 0,
            'total_points' => $totalPoints,
            'total_badges' => $totalBadges,
            'recent_attempts' => $recentAttempts,
        ]);
    }
}
