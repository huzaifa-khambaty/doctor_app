<?php

namespace Database\Seeders;

use App\Domain\Doctor\Models\User;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizQuestion;
use App\Domain\Shared\Models\QuizOption;
use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\QuizAttemptAnswer;
use App\Domain\Shared\Models\Specialty;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class LeaderboardSeeder extends Seeder
{
    public function run(): void
    {
        $specialties = [
            'Cardiology' => 1,
            'Pulmonology' => 2,
            'Neurology' => 3,
            'Endocrinology' => 4,
            'Pediatrics' => 5,
            'General Practice' => 6,
            'Oncology' => 7,
            'Orthopedics' => 8,
        ];

        $doctors = [
            ['full_name' => 'Dr. Elena Kostas',  'email' => 'elena.k@test.com',  'phone' => '+1000000001', 'points' => 12200, 'location' => 'New York',  'specialty' => 'Cardiology'],
            ['full_name' => 'Dr. Aris Vangelis', 'email' => 'aris.v@test.com',   'phone' => '+1000000002', 'points' => 9400,  'location' => 'Athens',    'specialty' => 'Pulmonology'],
            ['full_name' => 'Dr. Marcus Liu',    'email' => 'marcus.l@test.com',  'phone' => '+1000000003', 'points' => 8900,  'location' => 'London',    'specialty' => 'Neurology'],
            ['full_name' => 'Dr. Sarah Chen',    'email' => 'sarah.c@test.com',   'phone' => '+1000000004', 'points' => 8240,  'location' => 'Beijing',   'specialty' => 'Pulmonology'],
            ['full_name' => 'Dr. Julian Ross',   'email' => 'julian.r@test.com',  'phone' => '+1000000005', 'points' => 7815,  'location' => 'London',    'specialty' => 'General Practice'],
            ['full_name' => 'Dr. Maria Garcia',  'email' => 'maria.g@test.com',   'phone' => '+1000000006', 'points' => 7102,  'location' => 'Madrid',    'specialty' => 'General Practice'],
            ['full_name' => 'Dr. Amir Jafari',   'email' => 'amir.j@test.com',    'phone' => '+1000000007', 'points' => 6950,  'location' => 'Dubai',     'specialty' => 'Pulmonology'],
            ['full_name' => 'Dr. Priya Sharma',  'email' => 'priya.s@test.com',   'phone' => '+1000000008', 'points' => 6400,  'location' => 'Mumbai',    'specialty' => 'Endocrinology'],
            ['full_name' => 'Dr. James Okonkwo', 'email' => 'james.o@test.com',   'phone' => '+1000000009', 'points' => 5800,  'location' => 'Lagos',     'specialty' => 'Pediatrics'],
            ['full_name' => 'Dr. Lisa Mueller',  'email' => 'lisa.m@test.com',    'phone' => '+1000000010', 'points' => 5200,  'location' => 'Berlin',    'specialty' => 'Oncology'],
        ];

        $password = Hash::make('password');
        $users = [];

        foreach ($doctors as $doc) {
            $user = User::firstOrCreate(
                ['email' => $doc['email']],
                [
                    'uuid' => Str::uuid(),
                    'full_name' => $doc['full_name'],
                    'phone' => $doc['phone'],
                    'password' => $password,
                    'status' => 'verified',
                    'points' => $doc['points'],
                    'location' => $doc['location'],
                    'specialty_id' => $specialties[$doc['specialty']] ?? null,
                    'email_verified_at' => now(),
                    'verified_at' => now(),
                ]
            );
            $users[] = $user;
        }

        $quiz = Quiz::firstOrCreate(
            ['title' => 'Pulmonology Mastery'],
            [
                'description' => 'Test your pulmonology knowledge',
                'status' => 'published',
                'tie_breaker' => 'score_then_time',
                'opens_at' => now()->subDay(),
                'closes_at' => now()->addMonths(6),
            ]
        );

        $questionsData = [
            'What is the primary function of the lungs?',
            'Which condition is caused by narrowing of airways?',
            'What is COPD?',
            'Which gas is exchanged in the alveoli?',
            'What is the normal respiratory rate for adults?',
        ];

        $optionsData = [
            [
                ['text' => 'Gas exchange',             'correct' => true,  'explanation' => 'Lungs facilitate O2/CO2 exchange'],
                ['text' => 'Blood filtration',          'correct' => false, 'explanation' => null],
                ['text' => 'Nutrient absorption',       'correct' => false, 'explanation' => null],
                ['text' => 'Hormone production',        'correct' => false, 'explanation' => null],
            ],
            [
                ['text' => 'Asthma',                    'correct' => true,  'explanation' => 'Asthma causes airway narrowing'],
                ['text' => 'Diabetes',                  'correct' => false, 'explanation' => null],
                ['text' => 'Hypertension',              'correct' => false, 'explanation' => null],
                ['text' => 'Anemia',                    'correct' => false, 'explanation' => null],
            ],
            [
                ['text' => 'Chronic Obstructive Pulmonary Disease', 'correct' => true,  'explanation' => 'COPD is a group of lung diseases'],
                ['text' => 'Cardiac Output Pressure Deficit',       'correct' => false, 'explanation' => null],
                ['text' => 'Central Oxygen Processing Disorder',    'correct' => false, 'explanation' => null],
                ['text' => 'Chronic Oxygen Pathway Damage',         'correct' => false, 'explanation' => null],
            ],
            [
                ['text' => 'Oxygen and Carbon Dioxide', 'correct' => true,  'explanation' => 'Alveoli exchange O2 and CO2'],
                ['text' => 'Nitrogen and Oxygen',       'correct' => false, 'explanation' => null],
                ['text' => 'Hydrogen and Oxygen',       'correct' => false, 'explanation' => null],
                ['text' => 'Carbon Monoxide and Oxygen','correct' => false, 'explanation' => null],
            ],
            [
                ['text' => '12-20 breaths per minute',  'correct' => true,  'explanation' => 'Normal adult respiratory rate'],
                ['text' => '5-10 breaths per minute',   'correct' => false, 'explanation' => null],
                ['text' => '30-40 breaths per minute',  'correct' => false, 'explanation' => null],
                ['text' => '25-35 breaths per minute',  'correct' => false, 'explanation' => null],
            ],
        ];

        $questions = [];
        foreach ($questionsData as $index => $text) {
            $question = QuizQuestion::firstOrCreate(
                ['quiz_id' => $quiz->id, 'question_text' => $text],
                ['order' => $index + 1]
            );
            $questions[] = $question;
        }

        $correctOptionIds = [];
        foreach ($questions as $qIndex => $question) {
            foreach ($optionsData[$qIndex] as $oIndex => $opt) {
                $option = QuizOption::firstOrCreate(
                    ['quiz_question_id' => $question->id, 'option_text' => $opt['text']],
                    [
                        'is_correct' => $opt['correct'],
                        'explanation' => $opt['explanation'],
                        'order' => $oIndex + 1,
                    ]
                );
                if ($opt['correct']) {
                    $correctOptionIds[$question->id] = $option->id;
                }
            }
        }

        $attemptsConfig = [
            ['score' => 5, 'duration' => 300, 'answers' => [1,1,1,1,1]],
            ['score' => 4, 'duration' => 420, 'answers' => [1,1,1,0,1]],
            ['score' => 4, 'duration' => 360, 'answers' => [1,1,0,1,1]],
            ['score' => 3, 'duration' => 420, 'answers' => [1,1,0,0,1]],
            ['score' => 3, 'duration' => 480, 'answers' => [1,0,1,0,1]],
            ['score' => 2, 'duration' => 600, 'answers' => [1,0,0,1,0]],
            ['score' => 2, 'duration' => 540, 'answers' => [0,1,0,1,0]],
            ['score' => 2, 'duration' => 600, 'answers' => [0,1,0,0,1]],
            ['score' => 1, 'duration' => 480, 'answers' => [0,0,0,0,1]],
            ['score' => 1, 'duration' => 600, 'answers' => [0,0,0,0,1]],
        ];

        foreach ($users as $uIndex => $user) {
            $config = $attemptsConfig[$uIndex];
            $submittedAt = now()->subHours(10 - $uIndex);

            $attempt = QuizAttempt::firstOrCreate(
                ['quiz_id' => $quiz->id, 'user_id' => $user->id],
                [
                    'started_at' => $submittedAt->copy()->subMinutes(5),
                    'submitted_at' => $submittedAt,
                    'score' => $config['score'],
                    'duration_seconds' => $config['duration'],
                    'status' => 'submitted',
                ]
            );

            foreach ($questions as $qIndex => $question) {
                $isCorrect = (bool) $config['answers'][$qIndex];
                $selectedOptionId = $isCorrect
                    ? ($correctOptionIds[$question->id] ?? null)
                    : QuizOption::where('quiz_question_id', $question->id)
                        ->where('is_correct', false)
                        ->first()
                        ?->id;

                QuizAttemptAnswer::firstOrCreate(
                    ['quiz_attempt_id' => $attempt->id, 'quiz_question_id' => $question->id],
                    [
                        'quiz_option_id' => $selectedOptionId,
                        'is_correct' => $isCorrect,
                        'answered_at' => $submittedAt->copy()->subMinutes(5 - $qIndex),
                    ]
                );
            }
        }
    }
}
