<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Traits\HasFormattedDates;

class QuizAttempt extends Model
{
    use HasFormattedDates;
    protected $fillable = ['quiz_id', 'user_id', 'started_at', 'submitted_at', 'score', 'duration_seconds', 'status'];
    protected $casts = ['started_at' => 'datetime', 'submitted_at' => 'datetime'];
    
    public function quiz() { return $this->belongsTo(Quiz::class); }
    public function user() { return $this->belongsTo(User::class); }
    public function answers() { return $this->hasMany(QuizAttemptAnswer::class); }
}
