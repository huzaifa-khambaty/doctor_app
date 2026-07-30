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
    ];

    protected $casts = [
        'responded_at' => 'datetime',
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
}
