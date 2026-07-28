<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class QueryMessage extends Model
{
    use HasFactory, HasFormattedDates;

    protected $fillable = [
        'query_id',
        'sender_type',
        'sender_id',
        'message',
        'read_at',
    ];

    protected $casts = [
        'read_at' => 'datetime',
    ];

    public function thread()
    {
        return $this->belongsTo(Query::class);
    }

    public function sender()
    {
        return $this->morphTo();
    }

    public function attachments()
    {
        return $this->hasMany(QueryAttachment::class);
    }
}
