<?php

namespace App\Domain\Admin\Models;

use Spatie\Permission\Models\Permission as SpatiePermission;
use App\Domain\Shared\Traits\HasFormattedDates;

class Permission extends SpatiePermission
{
    use HasFormattedDates;
}
