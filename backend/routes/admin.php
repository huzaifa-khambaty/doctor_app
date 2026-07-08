<?php

use Illuminate\Support\Facades\Route;
use App\Domain\Admin\Http\Controllers\Api\AuthController;
use App\Domain\Admin\Http\Controllers\Api\UserController;
use App\Domain\Admin\Http\Controllers\Api\AdminController;
use App\Domain\Admin\Http\Controllers\Api\AccountDeletionController;
use App\Domain\Admin\Http\Controllers\Api\RoleController;
use App\Domain\Admin\Http\Controllers\Api\PermissionController;
use App\Domain\Shared\Http\Controllers\Api\SpecialtyController;
use App\Domain\Admin\Http\Controllers\Api\EventController;
use App\Domain\Admin\Http\Controllers\Api\AdminQuizController;

Route::prefix('admin/v1')->group(function () {
    Route::prefix('auth')->controller(AuthController::class)->group(function () {
        Route::post('login', 'login');

        Route::middleware(['auth:sanctum', 'ability:admin'])->group(function () {
            Route::post('logout', 'logout');
            Route::get('me', 'me');
        });
    });

    Route::middleware(['auth:sanctum', 'ability:admin'])->group(function () {
        Route::prefix('users')->controller(UserController::class)->group(function () {
            Route::get('trashed/list', 'trashed');
            Route::get('/', 'index');
            Route::post('/', 'store');
            Route::get('{user}', 'show');
            Route::put('{user}', 'update');
            Route::post('{user}/verify', 'verify');
            Route::post('{user}/reject', 'reject');
            Route::post('{user}/suspend', 'suspend');
            Route::post('{user}/reinstate', 'reinstate');
            Route::get('{user}/activity', 'activity');
            Route::post('{user}/restore', 'restore')->withTrashed();
            Route::delete('{user}/force-delete', 'forceDelete')->withTrashed();
            Route::delete('{user}', 'destroy');
        });

        Route::prefix('account-deletion-requests')->controller(AccountDeletionController::class)->group(function () {
            Route::get('/', 'index');
            Route::post('{deletionRequest}/process', 'process');
        });

        Route::apiResource('admins', AdminController::class);
        Route::apiResource('roles', RoleController::class);
        Route::apiResource('permissions', PermissionController::class)->only(['index', 'show']);
        
        // Quizzes
        Route::prefix('quizzes')->controller(AdminQuizController::class)->group(function () {
            Route::get('/', 'index');
            Route::post('/', 'store');
            Route::get('{quiz}', 'show');
            Route::put('{quiz}', 'update');
            Route::delete('{quiz}', 'destroy');
            Route::post('{quiz}/questions', 'storeQuestion');
            Route::put('{quiz}/questions/{question?}', 'updateQuestion');
            Route::delete('{quiz}/questions/{question}', 'destroyQuestion');
            Route::post('{quiz}/submit-for-review', 'submitForReview');
            Route::post('{quiz}/publish', 'publish');
            Route::get('{quiz}/leaderboard', 'leaderboard');
            Route::post('{quiz}/leaderboard/recalculate', 'recalculateLeaderboard');
        });

        Route::apiResource('events', EventController::class);
        
        Route::prefix('events')->controller(EventController::class)->group(function () {
            Route::patch('{event}/status', 'updateStatus');
            Route::get('{event}/registrations', 'registrations');
        });

        Route::get('specialties', [SpecialtyController::class, 'index']);
    });
});
