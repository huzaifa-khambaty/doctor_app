<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class Otp extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'otpable_id',
        'otpable_type',
        'channel',
        'code_hash',
        'purpose',
        'expires_at',
        'consumed_at',
        'attempts'
    ];

    protected $casts = [
        'expires_at' => 'datetime',
        'consumed_at' => 'datetime',
    ];

    public function otpable()
    {
        return $this->morphTo();
    }
}
