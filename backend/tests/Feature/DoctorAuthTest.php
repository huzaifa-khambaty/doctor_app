<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Domain\Shared\Models\Specialty;
use App\Domain\Doctor\Models\User;

class DoctorAuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_doctor_can_register_and_login_after_verification()
    {
        $specialty = Specialty::create(['name' => 'Cardio', 'slug' => 'cardio']);

        // 1. Register
        $response = $this->postJson('/api/v1/auth/register', [
            'full_name' => 'John Doe',
            'email' => 'john@example.com',
            'phone' => '1234567890',
            'specialties' => [$specialty->id],
            'hospital_affiliation' => 'General Hospital',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);
        $response->assertStatus(201);

        $user = User::where('email', 'john@example.com')->first();
        $this->assertNotNull($user);

        // 2. Login Blocked
        $loginResponse = $this->postJson('/api/v1/auth/login', [
            'identifier' => 'john@example.com',
            'password' => 'password123',
        ]);
        $loginResponse->assertStatus(403); // Pending verification

        // 3. Force Verification (Mocking OTP for simplicity in feature test)
        $user->update([
            'email_verified_at' => now(),
            'phone_verified_at' => now(),
        ]);

        // 4. Login Succeeds
        $loginResponse2 = $this->postJson('/api/v1/auth/login', [
            'identifier' => 'john@example.com',
            'password' => 'password123',
        ]);
        $loginResponse2->assertStatus(200);
        $loginResponse2->assertJsonStructure(['token', 'doctor']);
    }
}
