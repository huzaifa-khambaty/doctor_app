<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Admin\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class AdminController extends Controller
{
    public function index(Request $request)
    {
        Gate::authorize('admins.view');

        $query = Admin::query()->with('roles');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%");
            });
        }

        $admins = $query->paginate(15);
        
        $admins->getCollection()->transform(function ($admin) {
            $admin->roles->makeHidden('pivot');
            return $admin;
        });

        return response()->json($admins);
    }

    public function store(Request $request)
    {
        Gate::authorize('admins.create');

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:admins',
            'password' => 'required|string|min:8|confirmed',
            'status' => 'nullable|in:active,inactive',
            'roles' => 'nullable|array',
            'roles.*' => 'exists:roles,name',
        ]);

        $validated['password'] = Hash::make($validated['password']);
        if (!isset($validated['status'])) {
            $validated['status'] = 'active';
        }

        $admin = Admin::create($validated);

        if (!empty($validated['roles'])) {
            $admin->assignRole($validated['roles']);
        }

        $admin->load('roles');
        $admin->roles->makeHidden('pivot');

        return response()->json([
            'message' => 'Admin created successfully.',
            'admin' => $admin
        ], 201);
    }

    public function show(Admin $admin)
    {
        Gate::authorize('admins.view');

        $admin->load('roles');
        $admin->roles->makeHidden('pivot');

        return response()->json($admin);
    }

    public function update(Request $request, Admin $admin)
    {
        Gate::authorize('admins.edit');

        $validated = $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'email' => ['sometimes', 'required', 'string', 'email', 'max:255', Rule::unique('admins')->ignore($admin->id)],
            'password' => 'nullable|string|min:8|confirmed',
            'status' => 'sometimes|required|in:active,inactive',
            'roles' => 'nullable|array',
            'roles.*' => 'exists:roles,name',
        ]);

        if (!empty($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        } else {
            unset($validated['password']);
        }

        $admin->update($validated);

        if (isset($validated['roles'])) {
            $admin->syncRoles($validated['roles']);
        }

        $admin->load('roles');
        $admin->roles->makeHidden('pivot');

        return response()->json([
            'message' => 'Admin updated successfully.',
            'admin' => $admin
        ]);
    }

    public function destroy(Admin $admin)
    {
        Gate::authorize('admins.delete');

        if ($admin->id === request()->user()->id) {
            return response()->json(['message' => 'You cannot delete yourself.'], 403);
        }

        $admin->delete();

        return response()->json(['message' => 'Admin deleted successfully.']);
    }
}
