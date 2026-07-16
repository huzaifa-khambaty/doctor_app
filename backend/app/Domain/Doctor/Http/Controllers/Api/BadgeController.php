<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\UserBadge;
use App\Domain\Shared\Models\Badge;
use App\Domain\Shared\Models\BadgeCategory;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class BadgeController extends Controller
{
    public function index(Request $request)
    {
        $badges = UserBadge::where('user_id', $request->user()->id)
            ->with('badge')
            ->orderByDesc('awarded_at')
            ->paginate($request->query('per_page', 15));

        return $this->jsonWithPagination($badges);
    }

    public function overview(Request $request)
    {
        $user = $request->user();
        $earnedBadgeIds = $user->badges()->pluck('badges.id');

        $categories = BadgeCategory::with(['badges' => function ($query) {
            $query->where('is_active', true);
        }, 'badges.userBadges' => function ($query) use ($user) {
            $query->where('user_id', $user->id);
        }])->orderBy('display_order')->get();

        $totalBadges = Badge::where('is_active', true)->count();
        $earnedBadges = $earnedBadgeIds->count();

        $categoriesData = $categories->map(function ($category) use ($user, $earnedBadgeIds) {
            $badges = $category->badges->map(function ($badge) use ($user, $earnedBadgeIds) {
                $earned = $earnedBadgeIds->contains($badge->id);
                $earnedAt = null;

                if ($earned) {
                    $userBadge = $badge->userBadges->where('user_id', $user->id)->first();
                    $earnedAt = $userBadge?->awarded_at;
                }

                return [
                    'id' => $badge->id,
                    'code' => $badge->code,
                    'name' => $badge->name,
                    'description' => $badge->description,
                    'icon' => $badge->icon_path,
                    'earned' => $earned,
                    'earned_at' => $earnedAt,
                ];
            });

            return [
                'id' => $category->id,
                'name' => $category->name,
                'earned' => $badges->where('earned', true)->count(),
                'total' => $badges->count(),
                'badges' => $badges->values(),
            ];
        });

        return response()->json([
            'total_badges' => $earnedBadges,
            'earned_badges' => $earnedBadges,
            'total_available' => $totalBadges,
            'categories' => $categoriesData,
        ]);
    }
}
