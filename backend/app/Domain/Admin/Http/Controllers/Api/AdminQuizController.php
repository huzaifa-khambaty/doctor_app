<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizQuestion;
use App\Domain\Shared\Models\QuizAttempt;
use App\Domain\Shared\Models\QuizAttemptAnswer;
use App\Domain\Shared\Services\BadgeAwardService;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\DB;

class AdminQuizController extends Controller
{
    public function index()
    {
        Gate::authorize('quizzes.view');

        $quizzes = Quiz::query()
            ->select('quizzes.id', 'quizzes.title', 'quizzes.topic_id', 'quizzes.status', 'quizzes.opens_at', 'quizzes.closes_at', 'quizzes.created_at')
            ->with('topic:id,name')
            ->withCount('questions')
            ->withCount(['attempts as participants_count' => fn ($q) => $q->whereNotNull('submitted_at')])
            ->with(['attempts' => fn ($q) => $q->whereNotNull('submitted_at')->select('id', 'quiz_id', 'user_id')])
            ->with('attempts.user:id,full_name')
            ->paginate(15);

        $quizzes->getCollection()->transform(fn ($quiz) => tap($quiz, function ($q) {
            $q->participants = $q->attempts->pluck('user')->filter()->values();
            unset($q->attempts);
        }));

        return response()->json($quizzes);
    }

    public function store(Request $request)
    {
        Gate::authorize('quizzes.create');

$validated = $request->validate([
            'title' => 'required|string|max:255',
            'banner' => 'nullable',
            'topic_id' => 'nullable|exists:topics,id',
            'description' => 'nullable|string',
            'opens_at' => 'nullable|date',
            'closes_at' => 'nullable|date|after:opens_at',
            'time_limit_minutes' => 'nullable|integer|min:1',
            'tie_breaker' => 'nullable|in:score_only,score_then_time',
        ]);

        unset($validated['banner']);
        if ($request->hasFile('banner')) {
            $validated['banner'] = $request->file('banner')->store('quizzes/banners', 'public');
        }

        $quiz = Quiz::create([
            ...$validated,
            'status' => 'draft',
            'created_by' => $request->user()->id,
        ]);

        return response()->json(['message' => 'Quiz created successfully.', 'quiz' => $quiz], 201);
    }

    public function show(Quiz $quiz)
    {
        Gate::authorize('quizzes.view');
        $quiz->load(['questions.options', 'createdBy:id,name']);
        return response()->json($quiz);
    }

    public function update(Request $request, Quiz $quiz)
    {
        Gate::authorize('quizzes.edit');

        if (!in_array($quiz->status, ['draft', 'review'])) {
            return response()->json(['message' => 'Cannot edit a published or closed quiz.'], 422);
        }

$validated = $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'banner' => 'nullable',
            'topic_id' => 'nullable|exists:topics,id',
            'description' => 'nullable|string',
            'opens_at' => 'nullable|date',
            'closes_at' => 'nullable|date|after:opens_at',
            'time_limit_minutes' => 'nullable|integer|min:1',
            'tie_breaker' => 'nullable|in:score_only,score_then_time',
        ]);

        unset($validated['banner']);
        if ($request->hasFile('banner')) {
            if ($quiz->banner) {
                \Storage::disk('public')->delete($quiz->banner);
            }
            $validated['banner'] = $request->file('banner')->store('quizzes/banners', 'public');
        }

        $quiz->update($validated);

        return response()->json(['message' => 'Quiz updated successfully.', 'quiz' => $quiz]);
    }

    public function storeQuestion(Request $request, Quiz $quiz)
    {
        //return ($request->all());
        Gate::authorize('quizzes.edit');

        if (!in_array($quiz->status, ['draft', 'review'])) {
            return response()->json(['message' => 'Cannot edit a published or closed quiz.'], 422);
        }

        $validated = $request->validate([
            'questions' => 'required_without:question_text|array',
            'questions.*.question_text' => 'required_with:questions|string',
            'questions.*.image_path' => 'nullable|image|max:2048',
            'questions.*.is_multiple' => 'nullable|boolean',
            'questions.*.order' => 'nullable|integer',
            'questions.*.options' => 'required_with:questions|array|min:2',
            'questions.*.options.*.option_text' => 'required_with:questions|string',
            'questions.*.options.*.is_correct' => 'required_with:questions|boolean',
            'questions.*.options.*.explanation' => 'nullable|string',

            'question_text' => 'required_without:questions|string',
            'image_path' => 'nullable|image|max:2048',
            'is_multiple' => 'nullable|boolean',
            'order' => 'nullable|integer',
            'options' => 'required_without:questions|array|min:2',
            'options.*.option_text' => 'required_without:questions|string',
            'options.*.is_correct' => 'required_without:questions|boolean',
            'options.*.explanation' => 'nullable|string',
        ]);

        $questionsToProcess = $request->has('questions')
            ? $validated['questions']
            : [[
                'question_text' => $validated['question_text'],
                'is_multiple' => $validated['is_multiple'] ?? false,
                'order' => $validated['order'] ?? null,
                'options' => $validated['options'] ?? []
            ]];

        foreach ($questionsToProcess as $index => $q) {
            $isMultiple = $q['is_multiple'] ?? false;
            $correctCount = collect($q['options'])->where('is_correct', true)->count();

            if ($isMultiple) {
                if ($correctCount < 1) {
                    return response()->json(['message' => 'At least one option must be correct for a multiple choice question.'], 422);
                }
            } else {
                if ($correctCount !== 1) {
                    return response()->json(['message' => 'Exactly one option must be correct for a single choice question.'], 422);
                }
            }
        }

        $createdQuestions = [];

        DB::beginTransaction();
        try {
            foreach ($questionsToProcess as $index => $q) {
                $imagePath = null;
                $fileKey = $request->has('questions') ? "questions.{$index}.image_path" : 'image_path';
                if ($request->hasFile($fileKey)) {
                    $file = $request->file($fileKey);
                    if ($file->getSize() > 2048 * 1024) {
                        DB::rollBack();
                        return response()->json(['message' => 'Image must not exceed 2MB.'], 422);
                    }
                    $imagePath = $file->store('quiz-images', 'public');
                }

                $question = $quiz->questions()->create([
                    'question_text' => $q['question_text'],
                    'image_path' => $imagePath,
                    'is_multiple' => $q['is_multiple'] ?? false,
                    'order' => $q['order'] ?? 0,
                ]);

                foreach ($q['options'] as $oIndex => $option) {
                    $question->options()->create([
                        'option_text' => $option['option_text'],
                        'is_correct' => $option['is_correct'],
                        'explanation' => $option['explanation'] ?? null,
                        'order' => $oIndex,
                    ]);
                }
                $createdQuestions[] = $question->load('options');
            }
            DB::commit();
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Failed to save questions.', 'error' => $e->getMessage()], 500);
        }

        if (!$request->has('questions')) {
            return response()->json(['message' => 'Question added successfully.', 'question' => $createdQuestions[0]], 201);
        }

        return response()->json(['message' => 'Questions added successfully.', 'questions' => $createdQuestions], 201);
    }

    public function updateQuestion(Request $request, Quiz $quiz, QuizQuestion $question = null)
    {
        Gate::authorize('quizzes.edit');

        if (!in_array($quiz->status, ['draft', 'review'])) {
            return response()->json(['message' => 'Cannot edit a published or closed quiz.'], 422);
        }

        if ($question && $question->quiz_id !== $quiz->id) {
            return response()->json(['message' => 'Question does not belong to this quiz.'], 404);
        }

        $validated = $request->validate([
            'questions' => 'required_without:question_text|array',
            'questions.*.id' => 'required_with:questions|exists:quiz_questions,id',
            'questions.*.question_text' => 'required_with:questions|string',
            'questions.*.image_path' => 'nullable|image|max:2048',
            'questions.*.is_multiple' => 'nullable|boolean',
            'questions.*.order' => 'nullable|integer',
            'questions.*.options' => 'required_with:questions|array|min:2',
            'questions.*.options.*.id' => 'nullable|exists:quiz_options,id',
            'questions.*.options.*.option_text' => 'required_with:questions|string',
            'questions.*.options.*.is_correct' => 'required_with:questions|boolean',
            'questions.*.options.*.explanation' => 'nullable|string',

            'question_text' => 'required_without:questions|string',
            'image_path' => 'nullable|image|max:2048',
            'is_multiple' => 'nullable|boolean',
            'order' => 'nullable|integer',
            'options' => 'required_without:questions|array|min:2',
            'options.*.id' => 'nullable|exists:quiz_options,id',
            'options.*.option_text' => 'required_without:questions|string',
            'options.*.is_correct' => 'required_without:questions|boolean',
            'options.*.explanation' => 'nullable|string',
        ]);

        $questionsToProcess = $request->has('questions')
            ? $validated['questions']
            : [[
                'id' => $question->id,
                'question_text' => $validated['question_text'],
                'is_multiple' => $validated['is_multiple'] ?? false,
                'order' => $validated['order'] ?? null,
                'options' => $validated['options'] ?? []
            ]];

        foreach ($questionsToProcess as $q) {
            $isMultiple = $q['is_multiple'] ?? false;
            $correctCount = collect($q['options'])->where('is_correct', true)->count();

            if ($isMultiple) {
                if ($correctCount < 1) {
                    return response()->json(['message' => 'At least one option must be correct for a multiple choice question.'], 422);
                }
            } else {
                if ($correctCount !== 1) {
                    return response()->json(['message' => 'Exactly one option must be correct for a single choice question.'], 422);
                }
            }
        }

        $updatedQuestions = [];

        DB::beginTransaction();
        try {
            foreach ($questionsToProcess as $index => $q) {
                $qModel = $quiz->questions()->findOrFail($q['id']);

                $imagePath = $qModel->image_path;
                $fileKey = $request->has('questions') ? "questions.{$index}.image_path" : 'image_path';
                if ($request->hasFile($fileKey)) {
                    $file = $request->file($fileKey);
                    if ($file->getSize() > 2048 * 1024) {
                        DB::rollBack();
                        return response()->json(['message' => 'Image must not exceed 2MB.'], 422);
                    }
                    if ($qModel->image_path) {
                        \Storage::disk('public')->delete($qModel->image_path);
                    }
                    $imagePath = $file->store('quiz-images', 'public');
                }

                $qModel->update([
                    'question_text' => $q['question_text'],
                    'image_path' => $imagePath,
                    'is_multiple' => $q['is_multiple'] ?? false,
                    'order' => $q['order'] ?? 0,
                ]);

                $existingOptionIds = $qModel->options()->pluck('id')->toArray();
                $providedOptionIds = array_filter(array_column($q['options'], 'id'));

                $optionsToDelete = array_diff($existingOptionIds, $providedOptionIds);
                if (!empty($optionsToDelete)) {
                    $qModel->options()->whereIn('id', $optionsToDelete)->delete();
                }

                foreach ($q['options'] as $oIndex => $option) {
                    $qModel->options()->updateOrCreate(
                        ['id' => $option['id'] ?? null],
                        [
                            'option_text' => $option['option_text'],
                            'is_correct' => $option['is_correct'],
                            'explanation' => $option['explanation'] ?? null,
                            'order' => $oIndex,
                        ]
                    );
                }
                $updatedQuestions[] = $qModel->load('options');
            }
            DB::commit();
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['message' => 'Failed to update questions.', 'error' => $e->getMessage()], 500);
        }

        if (!$request->has('questions')) {
            return response()->json(['message' => 'Question updated successfully.', 'question' => $updatedQuestions[0]]);
        }

        return response()->json(['message' => 'Questions updated successfully.', 'questions' => $updatedQuestions]);
    }

    public function destroyQuestion(Request $request, Quiz $quiz, QuizQuestion $question)
    {
        Gate::authorize('quizzes.edit');

        if (!in_array($quiz->status, ['draft', 'review'])) {
            return response()->json(['message' => 'Cannot edit a published or closed quiz.'], 422);
        }

        if ($question->quiz_id !== $quiz->id) {
            return response()->json(['message' => 'Question does not belong to this quiz.'], 404);
        }

        $question->delete();

        return response()->json(['message' => 'Question deleted successfully.']);
    }

    public function submitForReview(Quiz $quiz)
    {
        Gate::authorize('quizzes.edit');

        if ($quiz->questions()->count() === 0) {
            return response()->json(['message' => 'Cannot submit for review without questions.'], 422);
        }

        $quiz->update(['status' => 'review']);

        return response()->json(['message' => 'Quiz submitted for review.']);
    }

    public function publish(Quiz $quiz)
    {
        Gate::authorize('quizzes.publish');

        if ($quiz->questions()->count() === 0) {
            return response()->json(['message' => 'Cannot publish a quiz without questions.'], 422);
        }

        $quiz->update(['status' => 'published']);

        return response()->json(['message' => 'Quiz published successfully.']);
    }

    public function destroy(Quiz $quiz)
    {
        Gate::authorize('quizzes.delete');

        if ($quiz->attempts()->whereNotNull('submitted_at')->exists()) {
            return response()->json(['message' => 'Cannot delete a quiz with submitted attempts.'], 422);
        }

        $quiz->delete();

        return response()->json(['message' => 'Quiz deleted successfully.']);
    }

    public function leaderboard(Quiz $quiz)
    {
        Gate::authorize('quizzes.leaderboard.manage');

        $attempts = $quiz->attempts()
            ->where('status', 'submitted')
            ->with('user:id,full_name,email')
            ->orderByDesc('score');

        if ($quiz->tie_breaker === 'score_then_time') {
            $attempts->orderBy('duration_seconds');
        } else {
            $attempts->orderBy('submitted_at');
        }

        return response()->json($attempts->get());
    }

    public function recalculateLeaderboard(Quiz $quiz, BadgeAwardService $badgeService)
    {
        Gate::authorize('quizzes.leaderboard.manage');

        DB::transaction(function () use ($quiz) {
            // Re-score all submitted attempts
            $attempts = $quiz->attempts()->where('status', 'submitted')->get();

            foreach ($attempts as $attempt) {
                // Re-evaluate correctness
                $answers = $attempt->answers()->with(['question.options', 'selectedOptions'])->get();
                $score = 0;
                
                foreach ($answers as $answer) {
                    $question = $answer->question;
                    $isCorrect = false;
                    
                    if ($question) {
                        $correctOptionIds = $question->options->where('is_correct', true)->pluck('id')->toArray();
                        $selectedOptionIds = $answer->selectedOptions->pluck('id')->toArray();
                        
                        // Backwards compatibility: if selectedOptions is empty, use quiz_option_id
                        if (empty($selectedOptionIds) && $answer->quiz_option_id) {
                            $selectedOptionIds = [$answer->quiz_option_id];
                        }
                        
                        sort($correctOptionIds);
                        sort($selectedOptionIds);
                        
                        if (!empty($selectedOptionIds) && $correctOptionIds === $selectedOptionIds) {
                            $isCorrect = true;
                        }
                    }
                    
                    if ($answer->is_correct !== $isCorrect) {
                        $answer->update(['is_correct' => $isCorrect]);
                    }
                    
                    if ($isCorrect) {
                        $score++;
                    }
                }

                if ($attempt->score !== $score) {
                    $attempt->update(['score' => $score]);
                }
            }
        });

        // Bust cache
        \Illuminate\Support\Facades\Cache::forget("quiz_{$quiz->id}_leaderboard");

        // Re-run BadgeAwardService (top 3 might have changed, but it doesn't revoke existing ones easily)
        if ($quiz->status === 'closed') {
            $badgeService->evaluateTop3($quiz);
        }

        return response()->json(['message' => 'Leaderboard recalculated successfully.']);
    }

    public function unpublish(Quiz $quiz)
    {
        Gate::authorize('quizzes.publish');

        if ($quiz->status !== 'published') {
            return response()->json(['message' => 'Quiz is not published.'], 422);
        }

        $quiz->update(['status' => 'draft']);

        return response()->json(['message' => 'Quiz unpublished successfully.']);
    }

    public function generalAnalytics()
    {
        Gate::authorize('quizzes.view');
        
        $totalQuizzes = Quiz::count();
        $activeQuizzes = Quiz::where('status', 'published')
            ->where(function ($q) {
                $q->whereNull('closes_at')
                  ->orWhere('closes_at', '>=', now());
            })
            ->count();
        
        $totalAttempts = QuizAttempt::where('status', 'submitted')->count();
        
        $startedAttempts = QuizAttempt::count();
        $completionRate = $startedAttempts > 0 
            ? round(($totalAttempts / $startedAttempts) * 100, 2) 
            : 0;

        return response()->json([
            'total_quizzes' => $totalQuizzes,
            'active_quizzes' => $activeQuizzes,
            'total_participants' => $totalAttempts,
            'completion_rate' => $completionRate,
        ]);
    }

    public function quizAnalytics(Quiz $quiz)
    {
        Gate::authorize('quizzes.view');
        
        $totalStarted = $quiz->attempts()->count();
        $totalSubmitted = $quiz->attempts()->where('status', 'submitted')->count();
        
        $completionRate = $totalStarted > 0 
            ? round(($totalSubmitted / $totalStarted) * 100, 2) 
            : 0;
            
        $averageScore = $totalSubmitted > 0 
            ? round($quiz->attempts()->where('status', 'submitted')->avg('score'), 2) 
            : 0;
            
        $scoreDistribution = $quiz->attempts()
            ->where('status', 'submitted')
            ->select('score', DB::raw('count(*) as count'))
            ->groupBy('score')
            ->get()
            ->pluck('count', 'score');

        return response()->json([
            'quiz_id' => $quiz->id,
            'quiz_title' => $quiz->title,
            'total_started' => $totalStarted,
            'total_submitted' => $totalSubmitted,
            'completion_rate' => $completionRate,
            'average_score' => $averageScore,
            'score_distribution' => $scoreDistribution,
        ]);
    }
}
