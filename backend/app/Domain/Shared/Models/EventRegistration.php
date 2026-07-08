<?php

namespace App\Domain\Shared\Models;

use App\Domain\Doctor\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class EventRegistration extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'event_id',
        'user_id',
        'status',
        'reminded_at',
    ];

    protected $casts = [
        'reminded_at' => 'datetime',
    ];

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
