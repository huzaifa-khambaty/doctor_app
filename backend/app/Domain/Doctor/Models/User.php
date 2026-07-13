<?php

namespace App\Domain\Doctor\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Domain\Shared\Models\Specialty;
use App\Domain\Shared\Models\Otp;
use App\Domain\Shared\Models\AccountDeletionRequest;
use App\Domain\Admin\Models\Admin;
use App\Domain\Shared\Traits\HasFormattedDates;
use App\Domain\Shared\Traits\HasUuid;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Spatie\Activitylog\Traits\LogsActivity;
use Spatie\Activitylog\LogOptions;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes, HasFormattedDates, HasUuid, LogsActivity;

    protected $appends = ['photo_url'];

    protected $fillable = [
        'uuid',
        'full_name',
        'email',
        'phone',
        'password',
        'hospital_affiliation',
        'photo_path',
        'qualifications',
        'location',
        'status',
        'biometric_enabled',
        'email_verified_at',
        'phone_verified_at',
        'last_active_at',
        'rejection_reason',
        'verified_at',
        'verified_by',
        'medical_specialty_id',
        'license_number',
        'hospital_clinic_affiliation',
        'year_of_registration',
        'points',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'phone_verified_at' => 'datetime',
        'last_active_at' => 'datetime',
        'password' => 'hashed',
        'biometric_enabled' => 'boolean',
        'verified_at' => 'datetime',
        'year_of_registration' => 'integer',
        'points' => 'integer',
    ];

    public function scopeStatus(Builder $query, string $status)
    {
        return $query->where('status', $status);
    }

    public function specialties()
    {
        return $this->belongsToMany(Specialty::class);
    }

    public function medicalSpecialty()
    {
        return $this->belongsTo(Specialty::class, 'medical_specialty_id');
    }

    public function otps()
    {
        return $this->morphMany(Otp::class, 'otpable');
    }

    public function verifiedBy()
    {
        return $this->belongsTo(Admin::class, 'verified_by');
    }

    public function accountDeletionRequests()
    {
        return $this->hasMany(AccountDeletionRequest::class);
    }

    public function quizAttempts()
    {
        return $this->hasMany(\App\Domain\Shared\Models\QuizAttempt::class);
    }

    public function badges()
    {
        return $this->belongsToMany(\App\Domain\Shared\Models\Badge::class, 'user_badges', 'user_id', 'badge_id')
                    ->withPivot('awarded_at');
    }

    protected function photoUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->photo_path ? asset('storage/' . $this->photo_path) : null,
        );
    }

    public function getActivitylogOptions(): LogOptions
    {
        return LogOptions::defaults()
            ->logOnly(['full_name', 'email', 'phone', 'status', 'hospital_affiliation', 'location', 'medical_specialty_id', 'license_number', 'hospital_clinic_affiliation', 'year_of_registration'])
            ->logOnlyDirty()
            ->dontSubmitEmptyLogs()
            ->setDescriptionForEvent(fn(string $eventName) => "User profile has been {$eventName}");
    }
}
