<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class QuizAttemptAnswer extends Model
{
    use HasFormattedDates;
    protected $fillable = ['quiz_attempt_id', 'quiz_question_id', 'quiz_option_id', 'is_correct', 'answered_at'];
    protected $casts = ['is_correct' => 'boolean', 'answered_at' => 'datetime'];
    
    public function attempt() { return $this->belongsTo(QuizAttempt::class, 'quiz_attempt_id'); }
    public function question() { return $this->belongsTo(QuizQuestion::class, 'quiz_question_id'); }
    public function option() { return $this->belongsTo(QuizOption::class, 'quiz_option_id'); }
    
    public function selectedOptions()
    {
        return $this->belongsToMany(QuizOption::class, 'quiz_attempt_answer_options', 'quiz_attempt_answer_id', 'quiz_option_id')
                    ->withTimestamps();
    }
}
