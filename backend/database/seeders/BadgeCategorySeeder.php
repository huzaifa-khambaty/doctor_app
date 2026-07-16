<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\BadgeCategory;

class BadgeCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            ['name' => 'Quiz Mastery', 'display_order' => 1],
            ['name' => 'Engagement', 'display_order' => 2],
            ['name' => 'Learning', 'display_order' => 3],
        ];

        foreach ($categories as $data) {
            BadgeCategory::firstOrCreate(['name' => $data['name']], $data);
        }
    }
}
