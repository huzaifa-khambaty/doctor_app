<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class QueryCategory extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = ['name', 'slug'];

    public function queries()
    {
        return $this->hasMany(Query::class);
    }
}
