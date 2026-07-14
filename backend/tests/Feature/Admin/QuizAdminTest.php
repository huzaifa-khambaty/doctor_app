<?php

namespace Tests\Feature\Admin;

use App\Domain\Admin\Models\Admin;
use App\Domain\Shared\Models\Quiz;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Tests\TestCase;

class QuizAdminTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Setup permissions
        $permissions = ['quizzes.view', 'quizzes.create', 'quizzes.edit', 'quizzes.publish', 'quizzes.delete', 'quizzes.leaderboard.manage'];
        foreach ($permissions as $perm) {
            Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'admin']);
        }
        $role = Role::firstOrCreate(['name' => 'content_manager', 'guard_name' => 'admin']);
        $role->syncPermissions($permissions);

        $this->admin = Admin::create([
            'name' => 'Test Admin',
            'email' => 'admin@test.com',
            'password' => Hash::make('password'),
            'status' => 'active',
        ]);
        $this->admin->assignRole('content_manager');
        
        // Create sanctum token
        $this->token = $this->admin->createToken('test', ['admin'])->plainTextToken;
    }

    public function test_admin_can_create_quiz()
    {
        $response = $this->withHeaders(['Authorization' => 'Bearer ' . $this->token])
            ->postJson('/api/admin/v1/quizzes', [
                'title' => 'Respiratory Basics',
                'description' => 'A basic quiz',
                'tie_breaker' => 'score_then_time'
            ]);

        $response->assertStatus(201)
                 ->assertJsonPath('quiz.title', 'Respiratory Basics')
                 ->assertJsonPath('quiz.status', 'draft');

        $this->assertDatabaseHas('quizzes', [
            'title' => 'Respiratory Basics',
            'status' => 'draft'
        ]);
    }

    public function test_admin_can_add_questions_and_publish()
    {
        $quiz = Quiz::create(['title' => 'Test', 'status' => 'draft', 'created_by' => $this->admin->id]);

        $response = $this->withHeaders(['Authorization' => 'Bearer ' . $this->token])
            ->postJson("/api/admin/v1/quizzes/{$quiz->id}/questions", [
                'question_text' => 'What is COPD?',
                'options' => [
                    ['option_text' => 'A disease', 'is_correct' => true],
                    ['option_text' => 'A vitamin', 'is_correct' => false]
                ]
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('quiz_questions', ['question_text' => 'What is COPD?']);

        $publishResponse = $this->withHeaders(['Authorization' => 'Bearer ' . $this->token])
            ->postJson("/api/admin/v1/quizzes/{$quiz->id}/publish");
        $publishResponse->assertStatus(200);

        $this->assertDatabaseHas('quizzes', ['id' => $quiz->id, 'status' => 'published']);
    }
}