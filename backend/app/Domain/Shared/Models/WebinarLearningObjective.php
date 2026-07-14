<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class WebinarLearningObjective extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'webinar_detail_id',
        'objective',
        'sort_order',
    ];

    public function webinarDetail()
    {
        return $this->belongsTo(WebinarDetail::class);
    }
}
