<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class WorkshopDetail extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'event_id',
        'trainer_designation',
        'fee',
        'currency',
    ];

    protected $casts = [
        'fee' => 'decimal:2',
    ];

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function prerequisites()
    {
        return $this->hasMany(WorkshopPrerequisite::class)->orderBy('sort_order');
    }
}
