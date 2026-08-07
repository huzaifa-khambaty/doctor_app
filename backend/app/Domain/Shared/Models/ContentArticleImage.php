<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class ContentArticleImage extends Model
{
    use HasFactory, HasFormattedDates;

    protected $table = 'article_images';

    protected $fillable = ['content_library_id', 'path', 'filename', 'mime_type', 'size'];

    public function content()
    {
        return $this->belongsTo(ContentLibrary::class, 'content_library_id');
    }
}
