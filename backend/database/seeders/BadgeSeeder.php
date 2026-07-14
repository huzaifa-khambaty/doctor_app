<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\Badge;

class BadgeSeeder extends Seeder
{
    public function run(): void
    {
        $badges = [
            [
                'code' => 'first_quiz',
                'name' => 'First Attempt',
                'description' => 'Completed your first quiz!',
                'icon_path' => 'badges/first_quiz.png',
            ],
            [
                'code' => 'perfect_score',
                'name' => 'Perfect Score',
                'description' => 'Scored 100% on a quiz!',
                'icon_path' => 'badges/perfect_score.png',
            ],
            [
                'code' => 'streak_5',
                'name' => '5-Quiz Streak',
                'description' => 'Participated in 5 consecutive quizzes!',
                'icon_path' => 'badges/streak_5.png',
            ],
            [
                'code' => 'top_3',
                'name' => 'Podium Finisher',
                'description' => 'Finished in the top 3 on a quiz leaderboard!',
                'icon_path' => 'badges/top_3.png',
            ],
        ];

        foreach ($badges as $data) {
            Badge::firstOrCreate(['code' => $data['code']], $data);
        }
    }
}
