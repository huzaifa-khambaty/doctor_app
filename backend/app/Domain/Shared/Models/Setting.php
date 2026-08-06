<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class Setting extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'app_name',
        'app_email',
        'app_logo',
        'time_zone',
        'language',
    ];

    // protected $appends = ['app_logo_url'];

    public function getAppLogoUrlAttribute(): ?string
    {
        return $this->app_logo ? asset('storage/' . $this->app_logo) : null;
    }

    public static function getSettings(): self
    {
        return static::firstOrCreate(['id' => 1]);
    }
}
