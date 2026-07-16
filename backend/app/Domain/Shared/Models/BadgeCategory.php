<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class BadgeCategory extends Model
{
    use HasFormattedDates;

    protected $fillable = ['name', 'display_order'];

    public function badges()
    {
        return $this->hasMany(Badge::class, 'category_id');
    }
}
