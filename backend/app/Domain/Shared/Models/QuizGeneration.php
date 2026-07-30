<?php

namespace App\Domain\Shared\Models;

use Illuminate\Database\Eloquent\Model;
use App\Domain\Admin\Models\Admin;
use App\Domain\Shared\Traits\HasFormattedDates;

class QuizGeneration extends Model
{
    use HasFormattedDates;

    protected $fillable = [
        'admin_id',
        'topic',
        'prompt',
        'document_filename',
        'document_path',
        'generation_params',
        'generated_questions',
        'saved_questions',
        'status',
        'quiz_id',
    ];

    protected $casts = [
        'generation_params' => 'array',
        'generated_questions' => 'array',
        'saved_questions' => 'array',
    ];

    public function admin()
    {
        return $this->belongsTo(Admin::class);
    }

    public function quiz()
    {
        return $this->belongsTo(Quiz::class);
    }
}
