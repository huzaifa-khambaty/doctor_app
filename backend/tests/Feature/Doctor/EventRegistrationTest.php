<?php

namespace Tests\Feature\Doctor;

use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Models\Event;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class EventRegistrationTest extends TestCase
{
    use DatabaseTransactions;

    private function createDoctor()
    {
        $doctor = User::create([
            'full_name' => 'Dr. Test',
            'email' => uniqid() . '@test.com',
            'phone' => (string) rand(1000000000, 9999999999),
            'password' => bcrypt('password'),
            'status' => 'verified',
        ]);
        $token = $doctor->createToken('test', ['doctor'])->plainTextToken;
        $this->withHeader('Authorization', 'Bearer ' . $token);
        return $doctor;
    }

    public function test_can_list_published_events()
    {
        $doctor = $this->createDoctor();


        $admin = \App\Domain\Admin\Models\Admin::create([
            'name' => 'Admin',
            'email' => 'admin_test_'.uniqid().'@test.com',
            'password' => bcrypt('password')
        ]);

        Event::create([
            'title' => 'Published Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'published',
            'created_by' => $admin->id,
        ]);

        Event::create([
            'title' => 'Draft Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'draft',
            'created_by' => $admin->id,
        ]);

        $response = $this->getJson('/api/v1/events');
        $response->assertStatus(200);
        $this->assertCount(1, $response->json('data'));
        $this->assertEquals('Published Event', $response->json('data.0.title'));
        $this->assertFalse($response->json('data.0.is_registered'));
    }

    public function test_can_register_for_event()
    {
        $doctor = $this->createDoctor();


        $admin = \App\Domain\Admin\Models\Admin::create([
            'name' => 'Admin',
            'email' => 'admin_test_'.uniqid().'@test.com',
            'password' => bcrypt('password')
        ]);

        $event = Event::create([
            'title' => 'Published Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'published',
            'created_by' => $admin->id,
        ]);

        $response = $this->postJson("/api/v1/events/{$event->id}/register");
        $response->assertStatus(200);

        $this->assertDatabaseHas('event_registrations', [
            'event_id' => $event->id,
            'user_id' => $doctor->id,
            'status' => 'registered'
        ]);

        // Duplicate registration
        $response = $this->postJson("/api/v1/events/{$event->id}/register");
        $response->assertStatus(409);
    }

    public function test_cannot_register_for_past_event()
    {
        $doctor = $this->createDoctor();


        $admin = \App\Domain\Admin\Models\Admin::create([
            'name' => 'Admin',
            'email' => 'admin_test_'.uniqid().'@test.com',
            'password' => bcrypt('password')
        ]);

        $event = Event::create([
            'title' => 'Past Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->subDays(2),
            'status' => 'published',
            'created_by' => $admin->id,
        ]);

        $response = $this->postJson("/api/v1/events/{$event->id}/register");
        $response->assertStatus(422);
    }

    public function test_can_cancel_registration()
    {
        $doctor = $this->createDoctor();


        $admin = \App\Domain\Admin\Models\Admin::create([
            'name' => 'Admin',
            'email' => 'admin_test_'.uniqid().'@test.com',
            'password' => bcrypt('password')
        ]);

        $event = Event::create([
            'title' => 'Published Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'published',
            'created_by' => $admin->id,
        ]);

        $this->postJson("/api/v1/events/{$event->id}/register");
        
        $response = $this->deleteJson("/api/v1/events/{$event->id}/register");
        $response->assertStatus(200);

        $this->assertDatabaseHas('event_registrations', [
            'event_id' => $event->id,
            'user_id' => $doctor->id,
            'status' => 'cancelled'
        ]);
    }
}
