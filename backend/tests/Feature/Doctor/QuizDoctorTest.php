<?php

namespace Tests\Feature\Doctor;

use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizQuestion;
use App\Domain\Shared\Models\QuizOption;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class QuizDoctorTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::create([
            'full_name' => 'Test Doctor',
            'email' => 'doctor@test.com',
            'phone' => '1234567890',
            'password' => Hash::make('password'),
            'status' => 'verified',
            'email_verified_at' => now(),
            'phone_verified_at' => now(),
        ]);
        
        $this->unverifiedUser = User::create([
            'full_name' => 'Unverified Doctor',
            'email' => 'unverified@test.com',
            'phone' => '0987654321',
            'password' => Hash::make('password'),
            'status' => 'pending',
        ]);

        $this->quiz = Quiz::create([
            'title' => 'Test Quiz',
            'status' => 'published',
            'opens_at' => now()->subDay(),
            'closes_at' => now()->addDay()
        ]);

        $question = $this->quiz->questions()->create(['question_text' => 'Q1']);
        $this->correctOption = $question->options()->create(['option_text' => 'Correct', 'is_correct' => true, 'explanation' => 'Yes']);
        $this->wrongOption = $question->options()->create(['option_text' => 'Wrong', 'is_correct' => false]);
    }

    public function test_verified_doctor_can_start_quiz()
    {
        $response = $this->actingAs($this->user)->postJson("/api/v1/quizzes/{$this->quiz->id}/start");

        $response->assertStatus(200)
                 ->assertJsonPath('message', 'Quiz started successfully.');

        $this->assertDatabaseHas('quiz_attempts', [
            'quiz_id' => $this->quiz->id,
            'user_id' => $this->user->id,
            'status' => 'in_progress'
        ]);
    }

    public function test_unverified_doctor_blocked()
    {
        $response = $this->actingAs($this->unverifiedUser)->postJson("/api/v1/quizzes/{$this->quiz->id}/start");

        $response->assertStatus(403);
    }

    public function test_doctor_can_answer_and_submit()
    {
        $this->actingAs($this->user)->postJson("/api/v1/quizzes/{$this->quiz->id}/start");

        $answerResponse = $this->actingAs($this->user)->postJson("/api/v1/quizzes/{$this->quiz->id}/answer", [
            'question_id' => $this->correctOption->quiz_question_id,
            'option_id' => $this->correctOption->id
        ]);

        $answerResponse->assertStatus(200)
                       ->assertJsonPath('is_correct', true);

        $submitResponse = $this->actingAs($this->user)->postJson("/api/v1/quizzes/{$this->quiz->id}/submit");
        
        $submitResponse->assertStatus(200)
                       ->assertJsonPath('score', 1);

        $this->assertDatabaseHas('quiz_attempts', [
            'quiz_id' => $this->quiz->id,
            'user_id' => $this->user->id,
            'status' => 'submitted',
            'score' => 1
        ]);
    }
}