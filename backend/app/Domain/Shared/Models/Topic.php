<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class Topic extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = ['name', 'icon', 'slug', 'description', 'is_active'];

    public function quizzes()
    {
        return $this->hasMany(Quiz::class);
    }
}
