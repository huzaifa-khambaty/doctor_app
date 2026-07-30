<?php

namespace App\Providers;

use Illuminate\Support\Facades\Gate;
use Illuminate\Database\Eloquent\Relations\Relation;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Gate::policy(
            \App\Domain\Shared\Models\Event::class,
            \App\Domain\Admin\Policies\EventPolicy::class
        );

        $permissionGates = [
            'quizzes.create', 'quizzes.view', 'quizzes.edit', 'quizzes.delete',
            'quizzes.publish', 'quizzes.leaderboard.manage',
            'users.view', 'users.create', 'users.edit', 'users.verify',
            'users.suspend', 'users.delete', 'users.restore', 'users.force_delete',
            'users.manage',
            'roles.manage',
            'events.view', 'events.create',
            'content.view', 'content.create', 'content.edit', 'content.delete',
            'content.publish',
            'admins.view', 'admins.create', 'admins.edit', 'admins.delete',
        ];

        foreach ($permissionGates as $gate) {
            Gate::define($gate, fn ($user) => $user->hasPermissionTo($gate));
        }

        Relation::enforceMorphMap([
            'doctor' => \App\Domain\Doctor\Models\User::class,
            'admin' => \App\Domain\Admin\Models\Admin::class,
        ]);
    }
}
