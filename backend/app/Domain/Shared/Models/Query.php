<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Domain\Shared\Traits\HasFormattedDates;
use App\Domain\Doctor\Models\User;
use App\Domain\Admin\Models\Admin;

class Query extends Model
{
    use HasFactory, HasFormattedDates, SoftDeletes;

    protected $fillable = [
        'user_id',
        'query_category_id',
        'subject',
        'message',
        'status',
        'admin_response',
        'responded_at',
        'responded_by',
        'last_message_at',
        'doctor_read_at',
        'admin_read_at',
    ];

    protected $casts = [
        'responded_at' => 'datetime',
        'last_message_at' => 'datetime',
        'doctor_read_at' => 'datetime',
        'admin_read_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function category()
    {
        return $this->belongsTo(QueryCategory::class, 'query_category_id');
    }

    public function responder()
    {
        return $this->belongsTo(Admin::class, 'responded_by');
    }

    public function messages()
    {
        return $this->hasMany(QueryMessage::class)->orderBy('created_at');
    }

    public function latestMessage()
    {
        return $this->hasOne(QueryMessage::class)->latestOfMany();
    }

    public function unreadCountFor(string $userType): int
    {
        $readAt = $userType === 'admin' ? $this->admin_read_at : $this->doctor_read_at;

        if (!$readAt) {
            return $this->messages()->where('sender_type', '!=', $userType)->count();
        }

        return $this->messages()
            ->where('sender_type', '!=', $userType)
            ->where('created_at', '>', $readAt)
            ->count();
    }
}
