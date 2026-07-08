<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\PermissionRegistrar;

class RolePermissionSeeder extends Seeder
{
    public function run(): void
    {
        // Reset cached roles and permissions
        app()[PermissionRegistrar::class]->forgetCachedPermissions();

        $guard = 'admin';

        $permissions = [
            'users.view',
            'users.create',
            'users.edit',
            'users.verify',
            'users.suspend',
            'users.manage',
            'users.delete',
            'users.restore',
            'users.force_delete',
            'admins.view',
            'admins.create',
            'admins.edit',
            'admins.delete',
            'roles.manage',
            'events.view',
            'events.create',
            'events.edit',
            'events.publish',
            'events.delete',
            'quizzes.view',
            'quizzes.create',
            'quizzes.edit',
            'quizzes.publish',
            'quizzes.delete',
            'quizzes.leaderboard.manage',
        ];

        foreach ($permissions as $perm) {
            \Spatie\Permission\Models\Permission::firstOrCreate(['name' => $perm, 'guard_name' => $guard]);
        }

        $roles = [
            'super_admin',
            'content_manager',
            'verification_officer',
            'query_manager',
            'analytics_viewer'
        ];

        foreach ($roles as $roleName) {
            Role::firstOrCreate(['name' => $roleName, 'guard_name' => $guard]);
        }

        $superAdmin = Role::findByName('super_admin', $guard);
        $superAdmin->syncPermissions(\Spatie\Permission\Models\Permission::where('guard_name', $guard)->get());

        $contentManager = Role::findByName('content_manager', $guard);
        $contentManager->syncPermissions([
            'events.view', 'events.create', 'events.edit', 'events.publish', 'events.delete',
            'quizzes.view', 'quizzes.create', 'quizzes.edit', 'quizzes.publish', 'quizzes.delete', 'quizzes.leaderboard.manage'
        ]);

        $verificationOfficer = Role::findByName('verification_officer', $guard);
        $verificationOfficer->syncPermissions(['users.view', 'users.verify', 'users.suspend']);
    }
}
