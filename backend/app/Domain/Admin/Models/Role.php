<?php

namespace App\Domain\Admin\Models;

use Spatie\Permission\Models\Role as SpatieRole;
use App\Domain\Shared\Traits\HasFormattedDates;

class Role extends SpatieRole
{
    use HasFormattedDates;
}
