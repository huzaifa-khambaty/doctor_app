<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class ContentType extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = ['name', 'slug', 'is_active', 'display_order'];

    protected $casts = [
        'is_active' => 'boolean',
    ];

    public function contents()
    {
        return $this->hasMany(ContentLibrary::class, 'type_id');
    }
}
