<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\ContentView;
use App\Domain\Shared\Models\QuizAttempt;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index(Request $request)
    {
        $now = now();
        $thirtyDaysAgo = $now->copy()->subDays(30);
        $sixtyDaysAgo = $now->copy()->subDays(60);

        $activeDoctors = $this->getActiveDoctors($thirtyDaysAgo, $sixtyDaysAgo);
        $pendingVerifications = $this->getPendingVerifications();
        $quizParticipation = $this->getQuizParticipation($thirtyDaysAgo, $sixtyDaysAgo, $activeDoctors['count']);
        $libraryViews = $this->getLibraryViews($thirtyDaysAgo);
        $engagementTrend = $this->getEngagementTrend($thirtyDaysAgo);
        $verificationQueue = $this->getVerificationQueue();

        return response()->json([
            'stat_counts' => [
                'active_doctors' => $activeDoctors,
                'pending_verifications' => $pendingVerifications,
                'quiz_participation' => $quizParticipation,
                'library_views' => $libraryViews,
            ],
            'engagement_trend' => $engagementTrend,
            'verification_queue' => $verificationQueue,
        ]);
    }

    private function getActiveDoctors($thirtyDaysAgo, $sixtyDaysAgo): array
    {
        $current = User::where('status', 'verified')->count();
        $previous = User::where('status', 'verified')
            ->where('created_at', '<', $thirtyDaysAgo)
            ->where('created_at', '>=', $sixtyDaysAgo)
            ->count();

        return [
            'count' => $current,
            'change_percent' => $previous > 0 ? round((($current - $previous) / $previous) * 100, 1) : 0,
        ];
    }

    private function getPendingVerifications(): array
    {
        $count = User::where('status', 'pending')->count();
        $critical = User::where('status', 'pending')
            ->where('created_at', '<=', now()->subDays(7))
            ->count();

        return [
            'count' => $count,
            'critical' => $critical,
        ];
    }

    private function getQuizParticipation($thirtyDaysAgo, $sixtyDaysAgo, $activeDoctorsCount): array
    {
        $currentAttempters = QuizAttempt::where('created_at', '>=', $thirtyDaysAgo)
            ->distinct('user_id')
            ->count('user_id');

        $previousAttempters = QuizAttempt::where('created_at', '>=', $sixtyDaysAgo)
            ->where('created_at', '<', $thirtyDaysAgo)
            ->distinct('user_id')
            ->count('user_id');

        $previousActiveDoctors = User::where('status', 'verified')
            ->where('created_at', '<', $thirtyDaysAgo)
            ->count();

        $percentage = $activeDoctorsCount > 0
            ? round(($currentAttempters / $activeDoctorsCount) * 100, 1)
            : 0;

        $previousPercentage = $previousActiveDoctors > 0
            ? round(($previousAttempters / $previousActiveDoctors) * 100, 1)
            : 0;

        return [
            'percentage' => $percentage,
            'change_percent' => round($percentage - $previousPercentage, 1),
        ];
    }

    private function getLibraryViews($thirtyDaysAgo): array
    {
        $total = ContentLibrary::sum('views_count');
        $recent = ContentView::where('created_at', '>=', $thirtyDaysAgo)->count();

        return [
            'total' => (int) $total,
            'recent' => $recent,
        ];
    }

    private function getEngagementTrend($sevenDaysAgo): array
    {
        $labels = [];
        $views = [];
        $quizzes = [];

        for ($i = 6; $i >= 0; $i--) {
            $date = now()->subDays($i);
            $labels[] = $date->format('M d');

            $dayStart = $date->copy()->startOfDay();
            $dayEnd = $date->copy()->endOfDay();

            $views[] = ContentView::whereBetween('created_at', [$dayStart, $dayEnd])->count();
            $quizzes[] = QuizAttempt::whereBetween('created_at', [$dayStart, $dayEnd])->count();
        }

        return [
            'labels' => $labels,
            'views' => $views,
            'quizzes' => $quizzes,
        ];
    }

    private function getVerificationQueue(): array
    {
        return User::where('status', 'pending')
            ->with('specialty:id,name')
            ->orderBy('created_at', 'asc')
            ->limit(10)
            ->get()
            ->map(fn ($user) => [
                'id' => $user->id,
                'full_name' => $user->full_name,
                'specialty' => $user->specialty->name ?? null,
                'license_number' => $user->license_number,
                'photo_url' => $user->photo_url,
                'status' => $user->status,
                'applied_at' => $user->created_at->format('Y-m-d'),
            ])
            ->toArray();
    }
}
