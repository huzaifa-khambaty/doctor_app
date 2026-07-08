<?php

namespace App\Domain\Shared\Models;

use App\Domain\Admin\Models\Admin;
use App\Domain\Doctor\Models\User;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Domain\Shared\Traits\HasFormattedDates;

use Illuminate\Database\Eloquent\Casts\Attribute;

class Event extends Model
{
    use HasFactory, SoftDeletes, HasFormattedDates;

    protected $appends = ['banner_url'];

    protected $fillable = [
        'title',
        'type',
        'starts_at',
        'ends_at',
        'timezone',
        'location',
        'description',
        'banner_path',
        'external_join_link',
        'recording_link',
        'enable_qa_session',
        'certificate_of_participation',
        'send_email_reminders',
        'status',
        'created_by',
    ];

    protected $casts = [
        'starts_at' => 'datetime',
        'ends_at' => 'datetime',
        'enable_qa_session' => 'boolean',
        'certificate_of_participation' => 'boolean',
        'send_email_reminders' => 'boolean',
    ];

    public function creator()
    {
        return $this->belongsTo(Admin::class, 'created_by');
    }

    public function registrations()
    {
        return $this->hasMany(EventRegistration::class);
    }

    public function speakers()
    {
        return $this->belongsToMany(User::class, 'event_speaker');
    }

    public function scopePublished($query)
    {
        return $query->where('status', 'published');
    }

    protected function bannerUrl(): Attribute
    {
        return Attribute::make(
            get: fn () => $this->banner_path ? asset('storage/' . $this->banner_path) : null,
        );
    }
}
