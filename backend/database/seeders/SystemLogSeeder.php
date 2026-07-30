<?php

namespace Database\Seeders;

use App\Domain\Shared\Models\SystemLog;
use Illuminate\Database\Seeder;

class SystemLogSeeder extends Seeder
{
    public function run(): void
    {
        SystemLog::log(
            'quiz',
            'New Quiz Published',
            '"Pharmacological Interventions in Asthma" was moved to published by Dr. Thorne.',
            'Dr. Thorne',
            ['quiz_id' => 1]
        );

        SystemLog::log(
            'error',
            'PDF Upload Failed',
            '"Invasive Ventilation Protocol.pdf" failed validation due to file size limits.',
            null,
            ['filename' => 'Invasive Ventilation Protocol.pdf', 'error' => 'file_size_exceeded']
        );

        SystemLog::log(
            'event',
            'Event Registration Peak',
            '"Pulmonology Summit 2024" reached 85% capacity in the Geneva venue.',
            null,
            ['event_id' => 1, 'capacity_percent' => 85]
        );

        SystemLog::log(
            'content',
            'New Article Published',
            '"Introduction to Respiratory Physiology" by Dr. Julianne Reed is now live.',
            'Dr. Julianne Reed',
            ['content_id' => 1]
        );

        SystemLog::log(
            'quiz',
            'Quiz Attempt Milestone',
            '"Respiratory System Anatomy Mastery Quiz" reached 100 attempts.',
            null,
            ['quiz_id' => 2, 'total_attempts' => 100]
        );
    }
}
