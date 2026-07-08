<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\AccountDeletionRequest;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class AccountDeletionController extends Controller
{
    public function index()
    {
        Gate::authorize('users.manage');

        $requests = AccountDeletionRequest::with('user', 'processedBy')->paginate(15);
        
        return response()->json($requests);
    }

    public function process(Request $request, AccountDeletionRequest $deletionRequest)
    {
        Gate::authorize('users.manage');

        if ($deletionRequest->status === 'processed') {
            return response()->json(['message' => 'Request already processed.'], 422);
        }

        $user = $deletionRequest->user;
        
        // Soft delete the user
        $user->delete();
        $user->tokens()->delete();

        // Mark request as processed
        $deletionRequest->update([
            'status' => 'processed',
            'processed_at' => now(),
            'processed_by' => $request->user('admin')->id,
        ]);

        return response()->json(['message' => 'Account deletion processed.']);
    }
}
