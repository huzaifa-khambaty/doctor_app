<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Models\ContentLibrary;
use App\Domain\Shared\Models\ContentView;
use App\Domain\Shared\Models\ContentLike;
use App\Domain\Shared\Models\EventRegistration;
use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\Specialty;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\DB;

class EngagementAnalyticsController extends Controller
{
    public function index(Request $request)
    {
        $period = $request->query('period', 'weekly');
        $now = now();
        $thirtyDaysAgo = $now->copy()->subDays(30);
        $sixtyDaysAgo = $now->copy()->subDays(60);

        return response()->json([
            'stat_cards' => $this->getStatCards($thirtyDaysAgo, $sixtyDaysAgo),
            'engagement_trends' => $this->getEngagementTrends($period),
            'growth_by_specialty' => $this->getGrowthBySpecialty(),
            'top_performing_content' => $this->getTopPerformingContent(),
        ]);
    }

    private function getStatCards($thirtyDaysAgo, $sixtyDaysAgo): array
    {
        $activeDoctors = $this->getActiveDoctors($thirtyDaysAgo, $sixtyDaysAgo);
        $avgQuizScore = $this->getAvgQuizScore($thirtyDaysAgo, $sixtyDaysAgo);
        $eventRsvpRate = $this->getEventRsvpRate();
        $contentReach = $this->getContentReach($thirtyDaysAgo, $sixtyDaysAgo);

        return [
            'total_active_doctors' => $activeDoctors,
            'avg_quiz_score' => $avgQuizScore,
            'event_rsvp_rate' => $eventRsvpRate,
            'content_reach' => $contentReach,
        ];
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

    private function getAvgQuizScore($thirtyDaysAgo, $sixtyDaysAgo): array
    {
        $current = QuizAttempt::where('status', 'submitted')
            ->where('submitted_at', '>=', $thirtyDaysAgo)
            ->avg('score');

        $previous = QuizAttempt::where('status', 'submitted')
            ->where('submitted_at', '>=', $sixtyDaysAgo)
            ->where('submitted_at', '<', $thirtyDaysAgo)
            ->avg('score');

        return [
            'percentage' => round((float) $current, 1),
            'change_percent' => $previous > 0 ? round((($current - $previous) / $previous) * 100, 1) : 0,
        ];
    }

    private function getEventRsvpRate(): array
    {
        $totalUsers = User::where('status', 'verified')->count();
        $registeredUsers = EventRegistration::where('status', '!=', 'cancelled')
            ->distinct('user_id')
            ->count('user_id');

        $previousMonth = now()->copy()->subMonth();
        $prevTotalUsers = User::where('status', 'verified')
            ->where('created_at', '<', $previousMonth)
            ->count();
        $prevRegisteredUsers = EventRegistration::where('status', '!=', 'cancelled')
            ->where('created_at', '<', $previousMonth)
            ->distinct('user_id')
            ->count('user_id');

        $percentage = $totalUsers > 0 ? round(($registeredUsers / $totalUsers) * 100, 1) : 0;
        $previousPercentage = $prevTotalUsers > 0 ? round(($prevRegisteredUsers / $prevTotalUsers) * 100, 1) : 0;

        return [
            'percentage' => $percentage,
            'change_percent' => round($percentage - $previousPercentage, 1),
        ];
    }

    private function getContentReach($thirtyDaysAgo, $sixtyDaysAgo): array
    {
        $current = ContentView::where('created_at', '>=', $thirtyDaysAgo)->count();
        $previous = ContentView::where('created_at', '>=', $sixtyDaysAgo)
            ->where('created_at', '<', $thirtyDaysAgo)
            ->count();

        return [
            'count' => $current,
            'change_percent' => $previous > 0 ? round((($current - $previous) / $previous) * 100, 1) : 0,
        ];
    }

    private function getEngagementTrends(string $period): array
    {
        if ($period === 'monthly') {
            return $this->getMonthlyTrends();
        }

        return $this->getWeeklyTrends();
    }

    private function getWeeklyTrends(): array
    {
        $weeks = 12;
        $labels = [];
        $contentViews = [];
        $quizAttempts = [];

        for ($i = $weeks - 1; $i >= 0; $i--) {
            $weekStart = now()->subWeeks($i)->startOfWeek();
            $weekEnd = now()->subWeeks($i)->endOfWeek();

            $labels[] = $weekStart->format('M d') . ' - ' . $weekEnd->format('M d');

            $contentViews[] = ContentView::whereBetween('created_at', [$weekStart, $weekEnd])->count();
            $quizAttempts[] = QuizAttempt::where('created_at', '>=', $weekStart)
                ->where('created_at', '<=', $weekEnd)
                ->count();
        }

        return [
            'labels' => $labels,
            'content_views' => $contentViews,
            'quiz_attempts' => $quizAttempts,
        ];
    }

    private function getMonthlyTrends(): array
    {
        $months = 12;
        $labels = [];
        $contentViews = [];
        $quizAttempts = [];

        for ($i = $months - 1; $i >= 0; $i--) {
            $monthStart = now()->subMonths($i)->startOfMonth();
            $monthEnd = now()->subMonths($i)->endOfMonth();

            $labels[] = $monthStart->format('M Y');

            $contentViews[] = ContentView::whereBetween('created_at', [$monthStart, $monthEnd])->count();
            $quizAttempts[] = QuizAttempt::where('created_at', '>=', $monthStart)
                ->where('created_at', '<=', $monthEnd)
                ->count();
        }

        return [
            'labels' => $labels,
            'content_views' => $contentViews,
            'quiz_attempts' => $quizAttempts,
        ];
    }

    private function getGrowthBySpecialty(): array
    {
        $totalContent = ContentLibrary::where('status', 'published')->count();

        $specialtyData = DB::table('content_specialty')
            ->join('content_library', 'content_library.id', '=', 'content_specialty.content_id')
            ->join('specialties', 'specialties.id', '=', 'content_specialty.specialty_id')
            ->where('content_library.status', 'published')
            ->select('specialties.name', DB::raw('COUNT(content_library.id) as content_count'))
            ->groupBy('specialties.id', 'specialties.name')
            ->orderByDesc('content_count')
            ->get()
            ->map(fn ($item) => [
                'name' => $item->name,
                'content_count' => $item->content_count,
                'percentage' => $totalContent > 0 ? round(($item->content_count / $totalContent) * 100, 1) : 0,
            ]);

        return $specialtyData->toArray();
    }

    private function getTopPerformingContent(): array
    {
        return ContentLibrary::where('status', 'published')
            ->with(['type:id,name', 'specialties:id,name'])
            ->orderByDesc('views_count')
            ->limit(10)
            ->get()
            ->map(fn ($content) => [
                'id' => $content->id,
                'title' => $content->title,
                'type' => $content->type->name ?? null,
                'specialty' => $content->specialties->pluck('name')->implode(', ') ?: null,
                'views_count' => $content->views_count,
                'likes_count' => $content->likes_count,
            ])
            ->toArray();
    }
}
