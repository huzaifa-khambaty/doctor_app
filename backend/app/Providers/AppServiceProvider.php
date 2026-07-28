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

        Relation::enforceMorphMap([
            'doctor' => \App\Domain\Doctor\Models\User::class,
            'admin' => \App\Domain\Admin\Models\Admin::class,
        ]);
    }
}
