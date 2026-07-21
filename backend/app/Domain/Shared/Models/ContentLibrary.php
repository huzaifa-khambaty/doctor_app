<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Domain\Shared\Traits\HasFormattedDates;
use Illuminate\Database\Eloquent\Casts\Attribute;
use App\Domain\Admin\Models\Admin;

class ContentLibrary extends Model
{
    use HasFactory, SoftDeletes, HasFormattedDates;

    protected $table = 'content_library';

    protected $appends = ['thumbnail_url', 'pdf_url', 'webinar_url', 'read_time'];

    protected $fillable = [
        'title',
        'type_id',
        'description',
        'thumbnail_path',
        'pdf_path',
        'pages_count',
        'pdf_size',
        'content_link',
        'quiz_id',
        'webinar_path',
        'status',
        'scheduled_at',
        'published_at',
        'views_count',
        'likes_count',
        'downloads_count',
        'created_by',
    ];

    protected $casts = [
        'scheduled_at' => 'datetime',
        'published_at' => 'datetime',
        'views_count' => 'integer',
        'likes_count' => 'integer',
        'downloads_count' => 'integer',
    ];

    public function type()
    {
        return $this->belongsTo(ContentType::class, 'type_id');
    }

    public function specialties()
    {
        return $this->belongsToMany(Specialty::class, 'content_specialty', 'content_id', 'specialty_id');
    }

    public function externalLinks()
    {
        return $this->hasMany(ContentExternalLink::class, 'content_id');
    }

    public function quiz()
    {
        return $this->belongsTo(Quiz::class);
    }

    public function creator()
    {
        return $this->belongsTo(Admin::class, 'created_by');
    }

    public function bookmarks()
    {
        return $this->hasMany(ContentBookmark::class, 'content_id');
    }

    public function contentViews()
    {
        return $this->hasMany(ContentView::class, 'content_id');
    }

    public function likes()
    {
        return $this->hasMany(ContentLike::class, 'content_id');
    }

    public function downloads()
    {
        return $this->hasMany(ContentDownload::class, 'content_id');
    }

    public function scopePublished($query)
    {
        return $query->where('status', 'published');
            
    }

    public function scopeOfType($query, $type)
    {
        return $query->whereHas('type', fn ($q) => $q->where('slug', $type));
    }

    protected function thumbnailUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->thumbnail_path ? asset('storage/' . $this->thumbnail_path) : null,
        );
    }

    protected function pdfUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->pdf_path ? asset('storage/' . $this->pdf_path) : null,
        );
    }

    protected function webinarUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->webinar_path ? asset('storage/' . $this->webinar_path) : null,
        );
    }

    protected function readTime(): Attribute
    {
        return Attribute::make(
            get: function () {
                if (!$this->description) {
                    return null;
                }
                $wordCount = str_word_count(strip_tags($this->description));
                $minutes = max(1, (int) ceil($wordCount / 200));
                return $minutes . ' min read';
            },
        );
    }
}
