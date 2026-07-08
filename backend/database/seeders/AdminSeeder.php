<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Admin\Models\Admin;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        $admins = [
            ['email' => 'superadmin@respilink.test', 'name' => 'Super Admin', 'role' => 'super_admin'],
            ['email' => 'content@respilink.test', 'name' => 'Content Manager', 'role' => 'content_manager'],
            ['email' => 'verification@respilink.test', 'name' => 'Verification Officer', 'role' => 'verification_officer'],
            ['email' => 'query@respilink.test', 'name' => 'Query Manager', 'role' => 'query_manager'],
            ['email' => 'analytics@respilink.test', 'name' => 'Analytics Viewer', 'role' => 'analytics_viewer'],
        ];

        foreach ($admins as $data) {
            $admin = Admin::firstOrCreate(
                ['email' => $data['email']],
                [
                    'name' => $data['name'],
                    'password' => Hash::make('12345678'),
                    'status' => 'active',
                ]
            );

            if (!$admin->hasRole($data['role'])) {
                $admin->assignRole($data['role']);
            }
        }
    }
}
