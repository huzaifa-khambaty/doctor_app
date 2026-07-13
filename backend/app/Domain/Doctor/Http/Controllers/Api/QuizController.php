<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\QuizAttemptAnswer;
use App\Domain\Shared\Models\QuizOption;
use App\Domain\Shared\Services\LeaderboardService;
use App\Domain\Shared\Services\BadgeAwardService;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class QuizController extends Controller
{
    public function index(Request $request)
    {
        $status = $request->query('status', 'active');
        $query = Quiz::where('status', 'published')
            ->where(function ($q) {
                $q->whereNull('opens_at')
                  ->orWhere('opens_at', '<=', now());
            });

        if ($status === 'active') {
            $query->where(function ($q) {
                $q->whereNull('closes_at')
                  ->orWhere('closes_at', '>=', now());
            });
        } elseif ($status === 'closed') {
            $query->where('closes_at', '<', now());
        }

        $quizzes = $query->paginate($request->query('per_page', 15));

        return $this->jsonWithPagination($quizzes);
    }

    public function show(Request $request, Quiz $quiz)
    {
        $quiz->loadCount('questions');

        $attempt = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('user_id', $request->user()->id)
            ->first();

        $quiz->my_attempt_status = $attempt ? $attempt->status : 'not_started';

        if ($quiz->closes_at && $quiz->closes_at > now()) {
            $quiz->time_remaining_seconds = now()->diffInSeconds($quiz->closes_at);
        } else {
            $quiz->time_remaining_seconds = null;
        }

        return response()->json($quiz);
    }

    public function start(Request $request, Quiz $quiz)
    {
        if ($quiz->status !== 'published') {
            return response()->json(['message' => 'Quiz is not available.'], 403);
        }

        if ($quiz->opens_at && $quiz->opens_at > now()) {
            return response()->json(['message' => 'Quiz has not opened yet.'], 403);
        }

        if ($quiz->closes_at && $quiz->closes_at < now()) {
            return response()->json(['message' => 'Quiz has closed.'], 403);
        }

        if (config('quiz.require_verified_to_attempt', true) && $request->user()->status !== 'verified') {
            return response()->json(['message' => 'Only verified doctors can attempt quizzes.'], 403);
        }

        $attempt = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('user_id', $request->user()->id)
            ->first();

        if ($attempt) {
            return response()->json(['message' => 'You have already started or submitted this quiz.'], 409);
        }

        $attempt = QuizAttempt::create([
            'quiz_id' => $quiz->id,
            'user_id' => $request->user()->id,
            'status' => 'in_progress',
        ]);

        $questions = $quiz->questions()->with(['options' => function ($q) {
            // Hide the 'is_correct' and 'explanation' fields when starting the quiz
            $q->select('id', 'quiz_question_id', 'option_text', 'order');
        }])->get();

        return response()->json([
            'message' => 'Quiz started successfully.',
            'attempt_id' => $attempt->id,
            'questions' => $questions
        ]);
    }

    public function answer(Request $request, Quiz $quiz)
    {
        $validated = $request->validate([
            'answers' => 'required_without:question_id|array',
            'answers.*.question_id' => 'required_with:answers|exists:quiz_questions,id',
            'answers.*.option_id' => 'nullable|exists:quiz_options,id',
            'answers.*.option_ids' => 'nullable|array',
            'answers.*.option_ids.*' => 'exists:quiz_options,id',
            
            'question_id' => 'required_without:answers|exists:quiz_questions,id',
            'option_id' => 'nullable|exists:quiz_options,id',
            'option_ids' => 'nullable|array',
            'option_ids.*' => 'exists:quiz_options,id',
        ]);

        $attempt = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('user_id', $request->user()->id)
            ->where('status', 'in_progress')
            ->first();

        if (!$attempt) {
            return response()->json(['message' => 'No in-progress attempt found for this quiz.'], 404);
        }

        $answersToProcess = $request->has('answers') 
            ? $validated['answers'] 
            : [[
                'question_id' => $validated['question_id'],
                'option_id' => $validated['option_id'] ?? null,
                'option_ids' => $validated['option_ids'] ?? null
            ]];

        $results = [];

        foreach ($answersToProcess as $ans) {
            $isCorrect = false;
            $explanation = null;

            $question = \App\Domain\Shared\Models\QuizQuestion::with('options')->find($ans['question_id']);
            if ($question) {
                $correctOptionIds = $question->options->where('is_correct', true)->pluck('id')->toArray();
                
                $selectedOptionIds = [];
                if (!empty($ans['option_ids'])) {
                    $selectedOptionIds = (array) $ans['option_ids'];
                } elseif (!empty($ans['option_id'])) {
                    $selectedOptionIds = [$ans['option_id']];
                }

                sort($correctOptionIds);
                sort($selectedOptionIds);

                if (!empty($selectedOptionIds) && $correctOptionIds === $selectedOptionIds) {
                    $isCorrect = true;
                }

                $explanation = $question->options->where('is_correct', true)->pluck('explanation')->filter()->join('; ');
            }

            $attemptAnswer = QuizAttemptAnswer::updateOrCreate(
                [
                    'quiz_attempt_id' => $attempt->id,
                    'quiz_question_id' => $ans['question_id'],
                ],
                [
                    'quiz_option_id' => count($selectedOptionIds) === 1 ? $selectedOptionIds[0] : null,
                    'is_correct' => $isCorrect,
                    'answered_at' => now(),
                ]
            );

            $attemptAnswer->selectedOptions()->sync($selectedOptionIds);

            $results[] = [
                'question_id' => $ans['question_id'],
                'is_correct' => $isCorrect,
                'explanation' => $explanation,
            ];
        }

        if (!$request->has('answers')) {
            return response()->json([
                'is_correct' => $results[0]['is_correct'],
                'explanation' => $results[0]['explanation'],
            ]);
        }

        return response()->json(['results' => $results]);
    }

    public function submit(Request $request, Quiz $quiz, BadgeAwardService $badgeService)
    {
        $attempt = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('user_id', $request->user()->id)
            ->where('status', 'in_progress')
            ->first();

        if (!$attempt) {
            return response()->json(['message' => 'No in-progress attempt found.'], 404);
        }

        $submittedAt = now();
        $durationSeconds = (int) abs($attempt->started_at->diffInSeconds($submittedAt));

        $score = $attempt->answers()->where('is_correct', true)->count();

        $attempt->update([
            'status' => 'submitted',
            'submitted_at' => $submittedAt,
            'duration_seconds' => $durationSeconds,
            'score' => $score,
        ]);

        $pointsEarned = $score * 100;
        $request->user()->increment('points', $pointsEarned);

        $badgeService->evaluate($attempt);

        \Illuminate\Support\Facades\Cache::forget("quiz_{$quiz->id}_leaderboard");

        return response()->json([
            'message' => 'Quiz submitted successfully.',
            'score' => $score,
            'duration_seconds' => $durationSeconds,
            'points_earned' => $pointsEarned,
        ]);
    }

    public function leaderboard(Request $request, Quiz $quiz, LeaderboardService $leaderboardService)
    {
        $limit = (int) $request->query('per_page', 10);
        $ranked = $leaderboardService->rank($quiz, $limit);
        $myRank = $leaderboardService->myRank($quiz, $request->user());
        $total = $quiz->attempts()->where('status', 'submitted')->count();

        return response()->json([
            'leaderboard' => $ranked,
            'me' => $myRank,
            'pagination' => [
                'page' => 1,
                'per_page' => $limit,
                'total' => $total,
                'last_page' => (int) ceil($total / max($limit, 1)),
                'has_next' => $total > $limit,
                'has_previous' => false,
            ],
        ]);
    }

    public function result(Request $request, Quiz $quiz, LeaderboardService $leaderboardService)
    {
        $attempt = QuizAttempt::where('quiz_id', $quiz->id)
            ->where('user_id', $request->user()->id)
            ->where('status', 'submitted')
            ->with(['answers.question', 'answers.option'])
            ->first();

        if (!$attempt) {
            return response()->json(['message' => 'No submitted attempt found.'], 404);
        }

        $myRank = $leaderboardService->myRank($quiz, $request->user());

        return response()->json([
            'attempt' => $attempt,
            'rank' => $myRank ? $myRank['rank'] : null,
        ]);
    }
}
