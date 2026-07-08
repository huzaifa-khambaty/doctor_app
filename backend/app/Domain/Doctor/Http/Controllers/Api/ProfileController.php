<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Routing\Controller;

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
}
