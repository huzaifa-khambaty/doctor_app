<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Domain\Admin\Models\Admin;
use Spatie\Permission\Models\Role;

class AdminAuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_admin_can_login_and_access_protected_route()
    {
        $role = Role::create(['name' => 'super_admin', 'guard_name' => 'admin']);
        $admin = Admin::create([
            'name' => 'Admin User',
            'email' => 'admin@respilink.test',
            'password' => \Illuminate\Support\Facades\Hash::make('password'),
            'status' => 'active',
        ]);
        $admin->assignRole('super_admin');

        $loginResponse = $this->postJson('/api/admin/v1/auth/login', [
            'email' => 'admin@respilink.test',
            'password' => 'password',
        ]);

        $loginResponse->assertStatus(200);
        $loginResponse->assertJsonStructure(['token', 'admin']);
        
        $token = $loginResponse->json('token');

        $meResponse = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/admin/v1/auth/me');

        $meResponse->assertStatus(200);
        $this->assertEquals('admin@respilink.test', $meResponse->json('data.email'));
    }
}
