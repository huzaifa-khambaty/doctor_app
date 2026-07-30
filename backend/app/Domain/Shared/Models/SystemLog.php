<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class SystemLog extends Model
{
    use HasFormattedDates;

    protected $fillable = [
        'category',
        'title',
        'description',
        'causer_name',
        'metadata',
    ];

    protected $casts = [
        'metadata' => 'array',
    ];

    const COLORS = [
        'quiz' => '#16A34A',
        'content' => '#2563EB',
        'event' => '#F59E0B',
        'error' => '#DC2626',
    ];

    public function getColorAttribute(): string
    {
        return self::COLORS[$this->category] ?? '#6B7280';
    }

    public function getTimeAgoAttribute(): string
    {
        $diff = now()->diffInSeconds($this->created_at);

        if ($diff < 60) {
            return 'JUST NOW';
        } elseif ($diff < 3600) {
            $mins = floor($diff / 60);
            return $mins . ' MINUTE' . ($mins > 1 ? 'S' : '') . ' AGO';
        } elseif ($diff < 86400) {
            $hours = floor($diff / 3600);
            return $hours . ' HOUR' . ($hours > 1 ? 'S' : '') . ' AGO';
        } else {
            $days = floor($diff / 86400);
            return $days . ' DAY' . ($days > 1 ? 'S' : '') . ' AGO';
        }
    }

    public function scopeRecent($query, int $limit = 10)
    {
        return $query->orderBy('created_at', 'desc')->limit($limit);
    }

    public function scopeOfCategory($query, string $category)
    {
        return $query->where('category', $category);
    }

    public static function log(string $category, string $title, string $description, ?string $causerName = null, ?array $metadata = null): self
    {
        return static::create([
            'category' => $category,
            'title' => $title,
            'description' => $description,
            'causer_name' => $causerName,
            'metadata' => $metadata,
        ]);
    }
}
