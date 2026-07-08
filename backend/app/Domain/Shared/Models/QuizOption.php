<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class QuizOption extends Model
{
    use HasFormattedDates;
    protected $fillable = ['quiz_question_id', 'option_text', 'is_correct', 'explanation', 'order'];
    protected $casts = ['is_correct' => 'boolean'];
    
    public function question() { return $this->belongsTo(QuizQuestion::class, 'quiz_question_id'); }
}
