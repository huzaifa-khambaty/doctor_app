<?php

use Illuminate\Support\Facades\Route;
use App\Domain\Doctor\Http\Controllers\Api\AuthController;
use App\Domain\Doctor\Http\Controllers\Api\ProfileController;
use App\Domain\Shared\Http\Controllers\Api\SpecialtyController;
use App\Domain\Doctor\Http\Controllers\Api\EventController;
use App\Domain\Doctor\Http\Controllers\Api\QuizController;
use App\Domain\Doctor\Http\Controllers\Api\BadgeController;
use App\Domain\Doctor\Http\Controllers\Api\QuizHomeController;

Route::prefix('v1')->group(function () {
    Route::prefix('auth')->controller(AuthController::class)->group(function () {
        Route::post('register', 'register');
        Route::post('otp/send', 'sendOtp');
        Route::post('otp/verify', 'verifyOtp');
        Route::post('login', 'login');
        Route::post('forgot-password', 'forgotPassword');
        Route::post('reset-password', 'resetPassword');

        Route::middleware(['auth:sanctum', 'ability:doctor'])->group(function () {
            Route::post('biometric/toggle', 'toggleBiometric');
            Route::post('logout', 'logout');
        });
    });

    Route::prefix('profile')->middleware(['auth:sanctum', 'ability:doctor'])->group(function () {
        Route::put('/', [ProfileController::class, 'update']);
        Route::get('verification-status', [ProfileController::class, 'verificationStatus']);
        Route::post('deletion-request', [ProfileController::class, 'requestDeletion']);
        Route::get('statistics', [ProfileController::class, 'statistics']);
    });

    Route::prefix('events')->middleware(['auth:sanctum', 'ability:doctor'])->controller(EventController::class)->group(function () {
        Route::get('mine', 'myEvents');
        Route::get('/', 'index');
        Route::get('webinars/{event}', 'webinarDetail');
        Route::get('conferences/{event}', 'conferenceDetail');
        Route::get('workshops/{event}', 'workshopDetail');
        Route::get('{event}', 'show');
        Route::post('{event}/register', 'register');
        Route::delete('{event}/register', 'cancelRegistration');
    });

    Route::prefix('quizzes')->middleware(['auth:sanctum', 'ability:doctor'])->group(function () {
        Route::get('home', [QuizHomeController::class, 'home']);

        Route::controller(QuizController::class)->group(function () {
            Route::get('/', 'index');
            Route::get('{quiz}', 'show');
            Route::get('{quiz}/questions', 'questions');
            Route::get('{quiz}/correct-answers', 'correctAnswers');
            Route::post('{quiz}/start', 'start');
            Route::post('{quiz}/answer', 'answer');
            Route::post('{quiz}/submit', 'submit');
            Route::get('{quiz}/leaderboard', 'leaderboard');
            Route::get('{quiz}/result', 'result');
        });
    });

    Route::middleware(['auth:sanctum', 'ability:doctor'])->group(function () {
        Route::get('topics/{topic}/quizzes', [QuizHomeController::class, 'topicQuizzes']);
    });

    Route::prefix('badges')->middleware(['auth:sanctum', 'ability:doctor'])->controller(BadgeController::class)->group(function () {
        Route::get('mine', 'index');
        Route::get('overview', 'overview');
    });

    Route::get('specialties', [SpecialtyController::class, 'index']);
});