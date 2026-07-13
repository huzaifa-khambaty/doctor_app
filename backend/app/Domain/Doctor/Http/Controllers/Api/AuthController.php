<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Domain\Doctor\Models\User;
use App\Domain\Doctor\Services\OtpService;
use App\Domain\Doctor\Http\Requests\RegisterDoctorRequest;
use App\Domain\Doctor\Http\Requests\LoginRequest;
use App\Domain\Doctor\Http\Requests\VerifyOtpRequest;
use App\Domain\Doctor\Http\Requests\ForgotPasswordRequest;
use App\Domain\Doctor\Http\Requests\ResetPasswordRequest;
use App\Domain\Doctor\Http\Resources\DoctorResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;

class AuthController extends Controller
{
    protected $otpService;

    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }

    public function register(RegisterDoctorRequest $request)
    {

    // return ($request->all());
        $user = User::create([
            'uuid' => (string) Str::uuid(),
            'full_name' => $request->full_name,
            'email' => $request->email,
            'phone' => $request->phone,
            'hospital_affiliation' => $request->hospital_affiliation,
            'password' => Hash::make($request->password),
            'status' => 'pending',
        ]);

        $user->specialties()->attach($request->specialties);

        $emailOtp = $this->otpService->generate($user, 'email', 'register');
        $phoneOtp = $this->otpService->generate($user, 'phone', 'register');

        activity()->causedBy($user)->log('Doctor registered an account');

        return response()->json([
            'message' => 'Registration successful. Please verify your account using the OTP.',
            'test_otps' => [
                'email' => $emailOtp->plain_code,
                'phone' => $phoneOtp->plain_code,
            ]
        ], 201);
    }

    public function sendOtp(Request $request)
    {
        $request->validate([
            'identifier' => 'required|string',
            'channel' => 'required|in:email,phone',
            'purpose' => 'required|in:register,login,reset',
        ]);

        $key = 'send-otp:' . $request->identifier . ':' . $request->purpose;
        if (RateLimiter::tooManyAttempts($key, 1)) {
            return response()->json(['message' => 'Too many requests. Please wait before requesting another OTP.'], 429);
        }
        RateLimiter::hit($key, 60);

        $user = User::where('email', $request->identifier)->orWhere('phone', $request->identifier)->firstOrFail();
        $otp = $this->otpService->generate($user, $request->channel, $request->purpose);

        return response()->json([
            'message' => 'OTP sent successfully.',
            'test_otp' => $otp->plain_code
        ]);
    }

    public function verifyOtp(VerifyOtpRequest $request)
    {
        $user = User::where('email', $request->identifier)->orWhere('phone', $request->identifier)->firstOrFail();
        
        $this->otpService->verify($user, $request->channel, $request->code, $request->purpose);

        if ($request->purpose === 'register') {
            if ($request->channel === 'email') {
                $user->update(['email_verified_at' => now()]);
            } else {
                $user->update(['phone_verified_at' => now()]);
            }
        }

        $user->load('specialties');

        return response()->json([
            'success' => true,
            'message' => 'OTP verified successfully.',
            'user' => $user
        ]);
    }

    public function login(LoginRequest $request)
    {
        $user = User::where('email', $request->identifier)->orWhere('phone', $request->identifier)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['message' => 'Invalid credentials.'], 401);
        }

        if (!$user->email_verified_at && !$user->phone_verified_at) {
            return response()->json(['message' => 'Please verify your account (email or phone).'], 403);
        }

        $user->update(['last_active_at' => now()]);

        activity()->causedBy($user)->log('Doctor logged in');

        $token = $user->createToken('doctor-access', ['doctor'])->plainTextToken;

        return response()->json([
            'token' => $token,
            'doctor' => new DoctorResource($user),
        ]);
    }

    public function forgotPassword(ForgotPasswordRequest $request)
    {
        $user = User::where('email', $request->identifier)->orWhere('phone', $request->identifier)->first();
        
        if (!$user) {
            return response()->json(['message' => 'Account not found.'], 404);
        }

        // Pick a channel based on the identifier type
        $channel = filter_var($request->identifier, FILTER_VALIDATE_EMAIL) ? 'email' : 'phone';
        $this->otpService->generate($user, $channel, 'reset');

        return response()->json(['message' => 'An OTP has been sent to your ' . $channel . '.']);
    }

    public function resetPassword(ResetPasswordRequest $request)
    {
        $user = User::where('email', $request->identifier)->orWhere('phone', $request->identifier)->firstOrFail();
        
        $channel = filter_var($request->identifier, FILTER_VALIDATE_EMAIL) ? 'email' : 'phone';
        $this->otpService->verify($user, $channel, $request->code, 'reset');

        $user->update([
            'password' => Hash::make($request->password)
        ]);

        $user->tokens()->delete();

        return response()->json(['message' => 'Password reset successfully. Please log in again.']);
    }

    public function toggleBiometric(Request $request)
    {
        $user = $request->user();
        $user->update(['biometric_enabled' => !$user->biometric_enabled]);
        $status = $user->biometric_enabled ? 'enabled' : 'disabled';
        return response()->json(['message' => "Biometric login {$status}."]);
    }

    public function logout(Request $request)
    {
        $user = $request->user();
        activity()->causedBy($user)->log('Doctor logged out');
        $user->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out successfully.']);
    }
}
