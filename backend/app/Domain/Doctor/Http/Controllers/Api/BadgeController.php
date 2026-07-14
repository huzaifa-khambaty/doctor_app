<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\UserBadge;
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
}
