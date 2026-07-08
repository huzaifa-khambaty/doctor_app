<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\UserBadge;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;

class BadgeController extends Controller
{
    public function index(Request $request)
    {
        $badges = UserBadge::where('user_id', $request->user()->id)
            ->with('badge')
            ->orderByDesc('awarded_at')
            ->get();

        return response()->json($badges);
    }
}
