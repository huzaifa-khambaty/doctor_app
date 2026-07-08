<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Shared\Traits\HasFormattedDates;

class QuizQuestion extends Model
{
    use HasFormattedDates;
    protected $fillable = ['quiz_id', 'question_text', 'image_path', 'order'];
    
    public function quiz() { return $this->belongsTo(Quiz::class); }
    public function options() { return $this->hasMany(QuizOption::class); }
}
