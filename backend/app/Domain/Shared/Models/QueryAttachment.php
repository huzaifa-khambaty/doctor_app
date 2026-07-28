<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class QueryAttachment extends Model
{
    use HasFactory;

    protected $fillable = [
        'query_message_id',
        'path',
        'original_name',
        'mime_type',
        'size',
    ];

    public function message()
    {
        return $this->belongsTo(QueryMessage::class, 'query_message_id');
    }

    public function getUrlAttribute(): string
    {
        return asset('storage/' . $this->path);
    }
}
