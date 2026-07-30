<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\QueryCategory;
use Illuminate\Support\Str;

class QueryCategorySeeder extends Seeder
{
    public function run(): void
    {
        $categories = ['Clinical', 'Technical', 'Billing', 'Other'];

        foreach ($categories as $name) {
            QueryCategory::firstOrCreate([
                'slug' => Str::slug($name)
            ], [
                'name' => $name
            ]);
        }
    }
}
