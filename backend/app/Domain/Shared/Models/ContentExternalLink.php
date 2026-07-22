<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class ContentExternalLink extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = ['content_id', 'url', 'label', 'display_order'];

    public function content()
    {
        return $this->belongsTo(ContentLibrary::class, 'content_id');
    }
}
