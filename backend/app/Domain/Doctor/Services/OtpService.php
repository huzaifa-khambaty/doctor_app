<?php

namespace App\Domain\Doctor\Services;

use App\Domain\Shared\Models\Otp;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Carbon\Carbon;

class OtpService
{
    /**
     * @param Model $otpable
     * @param string $channel 'email' or 'phone'
     * @param string $purpose 'register', 'login', or 'reset'
     * @return Otp
     */
    public function generate(Model $otpable, string $channel, string $purpose): Otp
    {
        // Invalidate any previous unconsumed OTP for this channel and purpose
        $otpable->otps()
            ->where('channel', $channel)
            ->where('purpose', $purpose)
            ->whereNull('consumed_at')
            ->update(['consumed_at' => now()]);

        $code = str_pad((string) random_int(100000, 999999), 6, '0', STR_PAD_LEFT);

        $otp = $otpable->otps()->create([
            'channel' => $channel,
            'code_hash' => Hash::make($code),
            'purpose' => $purpose,
            'expires_at' => now()->addMinutes(10),
            'attempts' => 0,
        ]);

        $this->dispatch($otpable, $channel, $code, $purpose);

        $otp->plain_code = $code; // Temporary for testing

        return $otp;
    }

    protected function dispatch(Model $otpable, string $channel, string $code, string $purpose)
    {
        if ($channel === 'email') {
            \Illuminate\Support\Facades\Mail::to($otpable->email)->send(new \App\Mail\OtpMail($code, $purpose));
            Log::info("Sent OTP via Email to {$otpable->email} for {$purpose}");
        } elseif ($channel === 'phone') {
            // Log driver implementation for SMS
            Log::info("Sending OTP via SMS to {$otpable->phone}: {$code} for {$purpose}");
        }
    }

    /**
     * @param Model $otpable
     * @param string $code
     * @param string $purpose
     * @return bool
     * @throws ValidationException
     */
    public function verify(Model $otpable, string $channel, string $code, string $purpose): bool
    {
        $otp = $otpable->otps()
            ->where('channel', $channel)
            ->where('purpose', $purpose)
            ->whereNull('consumed_at')
            ->latest()
            ->first();

        if (!$otp) {
            throw ValidationException::withMessages([
                'code' => ['Invalid or expired code.'],
            ]);
        }

        if ($otp->expires_at->isPast()) {
            throw ValidationException::withMessages([
                'code' => ['Code expired.'],
            ]);
        }

        if ($otp->attempts >= 5) {
            $otp->update(['consumed_at' => now()]);
            throw ValidationException::withMessages([
                'code' => ['Too many attempts, request a new code.'],
            ]);
        }

        if (!Hash::check($code, $otp->code_hash)) {
            $otp->increment('attempts');
            throw ValidationException::withMessages([
                'code' => ['Invalid code.'],
            ]);
        }

        $otp->update(['consumed_at' => now()]);

        return true;
    }
}
