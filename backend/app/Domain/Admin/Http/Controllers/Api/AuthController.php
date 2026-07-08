<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Domain\Admin\Models\Admin;
use App\Domain\Admin\Http\Requests\AdminLoginRequest;
use App\Domain\Admin\Http\Resources\AdminResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Spatie\Activitylog\Facades\Activity;

class AuthController extends Controller
{
    public function login(AdminLoginRequest $request)
    {
        $admin = Admin::where('email', $request->email)->first();

        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return response()->json(['message' => 'Invalid credentials.'], 401);
        }

        if ($admin->status !== 'active') {
            return response()->json(['message' => 'Account is disabled.'], 403);
        }

        $admin->update(['last_login_at' => now()]);

        activity()
            ->causedBy($admin)
            ->log('Admin logged in');

        $token = $admin->createToken('admin-access', ['admin'])->plainTextToken;

        return response()->json([
            'token' => $token,
            'admin' => new AdminResource($admin->load('roles')),
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out successfully.']);
    }

    public function me(Request $request)
    {
        return new AdminResource($request->user()->load('roles'));
    }
}
