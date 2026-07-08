<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Admin\Models\Permission;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class PermissionController extends Controller
{
    public function index()
    {
        Gate::authorize('roles.manage');
        return response()->json(Permission::all());
    }

    public function show(Permission $permission)
    {
        Gate::authorize('roles.manage');
        return response()->json($permission);
    }
}
