<?php

namespace App\Domain\Doctor\Http\Controllers\Api;

use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\QuizAttemptAnswer;
use App\Domain\Shared\Models\QuizOption;
use App\Domain\Shared\Services\LeaderboardService;
use App\Domain\Shared\Services\BadgeAwardService;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\DB;

class QuizController extends Controller
{
    public function index(Request $request)
    {
        $status = $request->query('status', 'active');
        $query = Quiz::where('status', 'published');

        if ($status === 'active') {
            $query->where(function ($q) {
                $q->whereNull('closes_at')
                  ->orWhere('closes_at', '>=', now());
            });
        } elseif ($status === 'closed') {
            $query->where('closes_at', '<', now());
        }

        return response()->json($query->paginate(15));
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
            'question_id' => 'required_without:answers|exists:quiz_questions,id',
            'option_id' => 'nullable|exists:quiz_options,id',
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
            : [['question_id' => $validated['question_id'], 'option_id' => $validated['option_id'] ?? null]];

        $results = [];

        foreach ($answersToProcess as $ans) {
            $isCorrect = false;
            $explanation = null;

            if (!empty($ans['option_id'])) {
                $option = QuizOption::find($ans['option_id']);
                if ($option && $option->quiz_question_id == $ans['question_id']) {
                    $isCorrect = $option->is_correct;
                    $explanation = $option->explanation;
                }
            }

            QuizAttemptAnswer::updateOrCreate(
                [
                    'quiz_attempt_id' => $attempt->id,
                    'quiz_question_id' => $ans['question_id'],
                ],
                [
                    'quiz_option_id' => $ans['option_id'] ?? null,
                    'is_correct' => $isCorrect,
                    'answered_at' => now(),
                ]
            );

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

        $badgeService->evaluate($attempt);

        \Illuminate\Support\Facades\Cache::forget("quiz_{$quiz->id}_leaderboard");

        return response()->json([
            'message' => 'Quiz submitted successfully.',
            'score' => $score,
            'duration_seconds' => $durationSeconds
        ]);
    }

    public function leaderboard(Request $request, Quiz $quiz, LeaderboardService $leaderboardService)
    {
        $ranked = $leaderboardService->rank($quiz, 10);
        $myRank = $leaderboardService->myRank($quiz, $request->user());

        return response()->json([
            'leaderboard' => $ranked,
            'me' => $myRank,
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
