<?php

namespace Database\Seeders;

use App\Domain\Shared\Models\Setting;
use Illuminate\Database\Seeder;

class SettingsSeeder extends Seeder
{
    public function run(): void
    {
        Setting::updateOrCreate(['id' => 1], [
            'app_name' => 'RespiLink Admin',
            'app_email' => 'support@respilink.org',
            'app_logo' => null,
            'time_zone' => 'EST',
            'language' => 'en',
        ]);
    }
}
