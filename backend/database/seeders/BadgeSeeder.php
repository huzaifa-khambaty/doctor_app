<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\Badge;
use App\Domain\Shared\Models\BadgeCategory;

class BadgeSeeder extends Seeder
{
    public function run(): void
    {
        $quizMasteryId = BadgeCategory::where('name', 'Quiz Mastery')->first()?->id;
        $engagementId = BadgeCategory::where('name', 'Engagement')->first()?->id;

        $badges = [
            // Quiz Mastery
            [
                'code' => 'first_quiz',
                'name' => 'First Attempt',
                'description' => 'Completed your first quiz!',
                'icon_path' => 'badges/first_quiz.png',
                'criteria_type' => 'quiz_completed',
                'criteria_value' => 1,
                'category_id' => $quizMasteryId,
            ],
            [
                'code' => 'perfect_score',
                'name' => 'Perfect Score',
                'description' => 'Scored 100% on a quiz!',
                'icon_path' => 'badges/perfect_score.png',
                'criteria_type' => 'perfect_score',
                'criteria_value' => 1,
                'category_id' => $quizMasteryId,
            ],
            [
                'code' => 'streak_5',
                'name' => '5-Quiz Streak',
                'description' => 'Participated in 5 consecutive quizzes!',
                'icon_path' => 'badges/streak_5.png',
                'criteria_type' => 'quiz_streak',
                'criteria_value' => 5,
                'category_id' => $quizMasteryId,
            ],
            [
                'code' => 'top_3',
                'name' => 'Podium Finisher',
                'description' => 'Finished in the top 3 on a quiz leaderboard!',
                'icon_path' => 'badges/top_3.png',
                'criteria_type' => 'leaderboard_rank',
                'criteria_value' => 3,
                'category_id' => $quizMasteryId,
            ],
            [
                'code' => 'fast_learner',
                'name' => 'Fast Learner',
                'description' => 'Finished quiz within time and scored 80% or above!',
                'icon_path' => 'badges/fast_learner.png',
                'criteria_type' => 'fast_learner',
                'criteria_value' => 1,
                'category_id' => $quizMasteryId,
            ],
            [
                'code' => 'expert',
                'name' => 'Expert',
                'description' => 'Average score of 90% or above over 20+ quizzes!',
                'icon_path' => 'badges/expert.png',
                'criteria_type' => 'expert',
                'criteria_value' => 20,
                'category_id' => $quizMasteryId,
            ],
            // Engagement
            [
                'code' => 'event_regular',
                'name' => 'Event Regular',
                'description' => 'Registered for 5 or more events!',
                'icon_path' => 'badges/event_regular.png',
                'criteria_type' => 'event_registered',
                'criteria_value' => 5,
                'category_id' => $engagementId,
                'is_active' => false,
            ],
        ];

        foreach ($badges as $data) {
            Badge::updateOrCreate(['code' => $data['code']], $data);
        }
    }
}
