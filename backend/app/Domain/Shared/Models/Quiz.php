<?php

namespace App\Domain\Shared\Models;
use Illuminate\Database\Eloquent\Model;
use App\Domain\Admin\Models\Admin;
use App\Domain\Shared\Traits\HasFormattedDates;

class Quiz extends Model
{
    use HasFormattedDates;
    protected $fillable = ['title', 'banner', 'topic_id', 'description', 'opens_at', 'closes_at', 'time_limit_minutes', 'status', 'tie_breaker', 'created_by'];
    protected $casts = ['opens_at' => 'datetime', 'closes_at' => 'datetime', 'time_limit_minutes' => 'integer'];
    
    public function questions() { return $this->hasMany(QuizQuestion::class); }
    public function attempts() { return $this->hasMany(QuizAttempt::class); }
    public function createdBy() { return $this->belongsTo(Admin::class, 'created_by'); }
    public function topic() { return $this->belongsTo(Topic::class); }
    public function specialties() { return $this->belongsToMany(Specialty::class, 'quiz_specialty', 'quiz_id', 'specialty_id'); }
}
