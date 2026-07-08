<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class Badge extends Model
{
    use HasFormattedDates;
    protected $fillable = ['code', 'name', 'description', 'icon_path'];
    
    public function userBadges() { return $this->hasMany(UserBadge::class); }
}
