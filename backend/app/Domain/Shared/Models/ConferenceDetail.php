<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class ConferenceDetail extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'event_id',
        'duration',
        'time',
        'format',
        'venue',
        'price',
        'currency',
    ];

    protected $casts = [
        'price' => 'decimal:2',
    ];

    public function event()
    {
        return $this->belongsTo(Event::class);
    }

    public function agendaItems()
    {
        return $this->hasMany(ConferenceAgendaItem::class)->orderBy('sort_order');
    }
}
