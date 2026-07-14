<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class ConferenceAgendaItem extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'conference_detail_id',
        'day',
        'time',
        'title',
        'description',
        'location',
        'sort_order',
    ];

    public function conferenceDetail()
    {
        return $this->belongsTo(ConferenceDetail::class);
    }
}
