<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Doctor\Models\User;

class ContentLike extends Model
{
    use HasFactory;

    protected $fillable = ['user_id', 'content_id'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function content()
    {
        return $this->belongsTo(ContentLibrary::class, 'content_id');
    }
}
