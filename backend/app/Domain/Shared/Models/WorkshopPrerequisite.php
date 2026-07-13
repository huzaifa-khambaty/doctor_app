<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class WorkshopPrerequisite extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'workshop_detail_id',
        'prerequisite',
        'sort_order',
    ];

    public function workshopDetail()
    {
        return $this->belongsTo(WorkshopDetail::class);
    }
}
