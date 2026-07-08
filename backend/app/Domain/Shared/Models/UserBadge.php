<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Traits\HasFormattedDates;

class UserBadge extends Model
{
    use HasFormattedDates;
    protected $fillable = ['user_id', 'badge_id', 'awarded_at'];
    protected $casts = ['awarded_at' => 'datetime'];
    public function user() { return $this->belongsTo(User::class); }
    public function badge() { return $this->belongsTo(Badge::class); }
}
