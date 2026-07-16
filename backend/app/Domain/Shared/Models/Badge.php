<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class Badge extends Model
{
    use HasFormattedDates;

    protected $fillable = [
        'code',
        'name',
        'description',
        'icon_path',
        'criteria_type',
        'criteria_value',
        'is_active',
        'category_id',
    ];

    public function category()
    {
        return $this->belongsTo(BadgeCategory::class, 'category_id');
    }

    public function userBadges()
    {
        return $this->hasMany(UserBadge::class);
    }
}
