<?php

namespace Tests\Feature\Admin;

use App\Domain\Admin\Models\Admin;
use App\Domain\Shared\Models\Event;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Tests\TestCase;

class EventManagementTest extends TestCase
{
    use DatabaseTransactions;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->app->make(\Spatie\Permission\PermissionRegistrar::class)->forgetCachedPermissions();
        
        $guard = 'admin';
        
        Permission::firstOrCreate(['name' => 'events.view', 'guard_name' => $guard]);
        Permission::firstOrCreate(['name' => 'events.create', 'guard_name' => $guard]);
        Permission::firstOrCreate(['name' => 'events.edit', 'guard_name' => $guard]);
        Permission::firstOrCreate(['name' => 'events.publish', 'guard_name' => $guard]);
        Permission::firstOrCreate(['name' => 'events.delete', 'guard_name' => $guard]);

        $role = Role::firstOrCreate(['name' => 'content_manager', 'guard_name' => $guard]);
        $role->givePermissionTo(['events.view', 'events.create', 'events.edit', 'events.publish', 'events.delete']);

        $restrictedRole = Role::firstOrCreate(['name' => 'restricted_admin', 'guard_name' => $guard]);
        $restrictedRole->givePermissionTo(['events.view', 'events.create', 'events.edit']);
    }

    private function createAdmin($roleName)
    {
        $admin = Admin::create([
            'name' => 'Test Admin',
            'email' => uniqid() . '@test.com',
            'password' => bcrypt('password'),
            'status' => 'active',
        ]);
        $admin->assignRole($roleName);
        $token = $admin->createToken('test', ['admin'])->plainTextToken;
        $this->withHeader('Authorization', 'Bearer ' . $token);
        return $admin;
    }

    public function test_can_create_draft_event()
    {
        Storage::fake('public');
        $admin = $this->createAdmin('content_manager');


        $file = UploadedFile::fake()->image('banner.jpg');

        $response = $this->postJson('/api/admin/v1/events', [
            'title' => 'New Webinar',
            'type' => 'webinar',
            'description' => 'Test',
            'starts_at' => now()->addDays(5)->toDateTimeString(),
            'banner' => $file,
        ]);

        $response->assertStatus(201);
        $this->assertEquals('draft', $response->json('event.status'));
        $this->assertNotNull($response->json('event.banner_url'));
    }

    public function test_workflow_draft_to_review_to_publish()
    {
        $admin = $this->createAdmin('content_manager');


        $event = Event::create([
            'title' => 'Test Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'draft',
            'created_by' => $admin->id,
        ]);

        // Submit for review
        $response = $this->postJson("/api/admin/v1/events/{$event->id}/submit-for-review");
        $response->assertStatus(200);
        $this->assertEquals('review', $event->fresh()->status);

        // Publish
        $response = $this->postJson("/api/admin/v1/events/{$event->id}/publish");
        $response->assertStatus(200);
        $this->assertEquals('published', $event->fresh()->status);

        // Unpublish
        $response = $this->postJson("/api/admin/v1/events/{$event->id}/unpublish");
        $response->assertStatus(200);
        $this->assertEquals('unpublished', $event->fresh()->status);
    }

    public function test_restricted_admin_cannot_publish()
    {
        $restricted = $this->createAdmin('restricted_admin');
        Sanctum::actingAs($restricted, ['admin'], 'admin');

        $event = Event::create([
            'title' => 'Test Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'review',
            'created_by' => $restricted->id,
        ]);

        $response = $this->postJson("/api/admin/v1/events/{$event->id}/publish");
        $response->assertStatus(403);
    }

    public function test_cannot_edit_published_event()
    {
        $admin = $this->createAdmin('content_manager');

        $event = Event::create([
            'title' => 'Test Event',
            'type' => 'webinar',
            'description' => 'Desc',
            'starts_at' => now()->addDays(2),
            'status' => 'published',
            'created_by' => $admin->id,
        ]);

        $response = $this->putJson("/api/admin/v1/events/{$event->id}", [
            'title' => 'Updated Title'
        ]);

        $response->assertStatus(403);
    }
}
