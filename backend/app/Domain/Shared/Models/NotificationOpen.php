<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;
use App\Domain\Doctor\Models\User;

class NotificationOpen extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'notification_id',
        'user_id',
        'opened_at',
    ];

    protected $casts = [
        'opened_at' => 'datetime',
    ];

    public function notification()
    {
        return $this->belongsTo(Notification::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
