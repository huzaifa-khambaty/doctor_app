<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;
use App\Domain\Admin\Models\Admin;

class Notification extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'title',
        'message',
        'audience_segment',
        'status',
        'schedule_at',
        'sent_at',
        'estimated_recipients',
        'created_by',
    ];

    protected $casts = [
        'schedule_at' => 'datetime',
        'sent_at' => 'datetime',
        'estimated_recipients' => 'integer',
    ];

    public function creator()
    {
        return $this->belongsTo(Admin::class, 'created_by');
    }

    public function scopeDraft($query)
    {
        return $query->where('status', 'draft');
    }

    public function scopeScheduled($query)
    {
        return $query->where('status', 'scheduled');
    }

    public function scopePublished($query)
    {
        return $query->where('status', 'published');
    }

    public function scopePendingSchedule($query)
    {
        return $query->where('status', 'scheduled')
                     ->where('schedule_at', '<=', now());
    }

    public static function getEstimatedRecipients(string $segment): int
    {
        $query = \App\Domain\Doctor\Models\User::query();

        switch ($segment) {
            case 'all_users':
                return $query->count();
            case 'verified':
                return $query->where('status', 'verified')->count();
            case 'pending':
                return $query->where('status', 'pending')->count();
            default:
                return 0;
        }
    }

    public function opens()
    {
        return $this->hasMany(NotificationOpen::class);
    }

    public function getOpenedCountAttribute(): int
    {
        return $this->opens()->count();
    }

    public function getOpenRateAttribute(): float
    {
        if ($this->estimated_recipients === 0) {
            return 0.0;
        }

        return round(($this->opens()->count() / $this->estimated_recipients) * 100, 1);
    }

    public function markOpenedBy(User $user): void
    {
        $this->opens()->firstOrCreate(
            [
                'user_id' => $user->id,
            ],
            [
                'opened_at' => now(),
            ]
        );
    }
}
