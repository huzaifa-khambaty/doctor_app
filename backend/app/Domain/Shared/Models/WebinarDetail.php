<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class WebinarDetail extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'event_id',
        'speaker_designation',
        'cme_credits',
        'format',
        'syllabus',
        'registration_fee',
        'currency',
    ];

    protected $casts = [
        'cme_credits' => 'decimal:2',
        'registration_fee' => 'decimal:2',
    ];

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function learningObjectives()
    {
        return $this->hasMany(WebinarLearningObjective::class)->orderBy('sort_order');
    }
}
