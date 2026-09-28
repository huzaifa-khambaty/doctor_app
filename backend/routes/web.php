<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PrivacyPolicyController;

Route::get('/', function () {
    return response('CareSynapse API Backend is running.', 200);
});

// Google Play Store Public Privacy Policy URL
Route::get('/privacy-policy', [PrivacyPolicyController::class, 'index'])->name('privacy.policy');
Route::redirect('/privacy', '/privacy-policy');

