<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Admin\Models\Role;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class RoleController extends Controller
{
    public function index()
    {
        Gate::authorize('roles.manage');
        return response()->json(Role::get());
    }

    public function store(Request $request)
    {
        Gate::authorize('roles.manage');
        $request->validate(['name' => 'required|string|unique:roles,name']);

        $role = Role::create(['name' => $request->name, 'guard_name' => 'admin']);
        if ($request->has('permissions')) {
            $role->syncPermissions($request->permissions);
        }

        return response()->json($role->load('permissions'), 201);
    }

    public function show(Role $role)
    {
        Gate::authorize('roles.manage');
        return response()->json($role->load('permissions'));
    }

    public function update(Request $request, Role $role)
    {
        Gate::authorize('roles.manage');
        $request->validate(['name' => 'string|unique:roles,name,' . $role->id]);

        if ($request->has('name')) {
            $role->update(['name' => $request->name]);
        }

        if ($request->has('permissions')) {
            $role->syncPermissions($request->permissions);
        }

        return response()->json($role->load('permissions'));
    }

    public function destroy(Role $role)
    {
        Gate::authorize('roles.manage');
        $role->delete();
        return response()->json(['message' => 'Role deleted successfully.']);
    }
}
