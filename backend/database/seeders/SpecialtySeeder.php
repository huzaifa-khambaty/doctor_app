<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\Specialty;
use Illuminate\Support\Str;

class SpecialtySeeder extends Seeder
{
    public function run(): void
    {
        $specialties = [
            'Cardiology', 'Pulmonology', 'Endocrinology', 'Neurology', 
            'Pediatrics', 'General Medicine', 'Dermatology', 'Oncology', 
            'Orthopedics', 'Psychiatry', 'Radiology', 'Gastroenterology'
        ];

        foreach ($specialties as $name) {
            Specialty::firstOrCreate([
                'slug' => Str::slug($name)
            ], [
                'name' => $name
            ]);
        }
    }
}
