<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\ContentType;

class ContentTypeSeeder extends Seeder
{
    public function run(): void
    {
        $types = [
            ['name' => 'PDF', 'slug' => 'pdf', 'is_active' => true, 'display_order' => 1],
            ['name' => 'Article', 'slug' => 'article', 'is_active' => true, 'display_order' => 2],
            ['name' => 'Webinar', 'slug' => 'webinar', 'is_active' => true, 'display_order' => 3],
            ['name' => 'Quiz', 'slug' => 'quiz', 'is_active' => true, 'display_order' => 4],
        ];

        foreach ($types as $data) {
            ContentType::updateOrCreate(['slug' => $data['slug']], $data);
        }
    }
}
