<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Model;
use App\Domain\Doctor\Models\User;
use App\Domain\Admin\Models\Admin;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use App\Domain\Shared\Traits\HasFormattedDates;

class AccountDeletionRequest extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'user_id',
        'reason',
        'status',
        'requested_at',
        'processed_at',
        'processed_by',
    ];

    protected $casts = [
        'requested_at' => 'datetime',
        'processed_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function processedBy()
    {
        return $this->belongsTo(Admin::class, 'processed_by');
    }
}
