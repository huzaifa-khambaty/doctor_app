<?php

namespace App\Domain\Shared\Models;

use Spatie\Activitylog\Models\Activity as SpatieActivity;
use App\Domain\Shared\Traits\HasFormattedDates;

class Activity extends SpatieActivity
{
    use HasFormattedDates;
}
