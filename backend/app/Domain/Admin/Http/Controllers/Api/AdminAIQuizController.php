<?php

namespace App\Domain\Admin\Http\Controllers\Api;

use App\Domain\Admin\Http\Requests\GenerateQuizRequest;
use App\Domain\Admin\Services\OpenAIQuizService;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Models\QuizGeneration;
use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Support\Facades\Gate;

class AdminAIQuizController extends Controller
{
    public function __construct(
        protected OpenAIQuizService $aiService
    ) {}

    /**
     * Generate quiz questions using AI
     *
     * POST /admin/v1/quizzes/ai/generate
     */
    public function generate(GenerateQuizRequest $request)
    {
        Gate::authorize('quizzes.create');

        try {
            $validated = $request->validated();

            $result = $this->aiService->generateQuiz(
                prompt: $validated['prompt'],
                topic: $validated['topic'] ?? null,
                questionCount: $validated['question_count'] ?? 10,
                difficulty: $validated['difficulty'] ?? 'medium',
                questionTypes: $validated['question_types'] ?? ['single', 'multiple'],
                document: $request->file('document'),
            );

            $generationParams = [
                'question_count' => $validated['question_count'] ?? 10,
                'difficulty' => $validated['difficulty'] ?? 'medium',
                'question_types' => $validated['question_types'] ?? ['single', 'multiple'],
            ];

            $generation = QuizGeneration::create([
                'admin_id' => $request->user()->id,
                'topic' => $result['topic'],
                'prompt' => $validated['prompt'],
                'document_filename' => $result['document_filename'],
                'document_path' => $result['document_path'],
                'generation_params' => $generationParams,
                'generated_questions' => $result['questions'],
                'status' => 'generated',
            ]);

            return response()->json([
                'message' => 'Quiz questions generated successfully.',
                'generation_id' => $generation->id,
                'questions' => $result['questions'],
                'total_questions' => count($result['questions']),
                'params' => $generationParams,
            ], 200);

        } catch (\RuntimeException $e) {
            return response()->json([
                'message' => 'Failed to generate quiz questions.',
                'error' => $e->getMessage(),
            ], 503);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'An unexpected error occurred.',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Link a quiz to its AI generation record
     *
     * POST /admin/v1/quizzes/ai/{generation}/link-quiz/{quiz}
     */
    public function linkQuiz(QuizGeneration $generation, Quiz $quiz)
    {
        Gate::authorize('quizzes.edit');

        if ($generation->quiz_id) {
            return response()->json([
                'message' => 'This generation is already linked to a quiz.',
            ], 422);
        }

        $generation->update([
            'quiz_id' => $quiz->id,
            'saved_questions' => $quiz->questions()->with('options')->get(),
            'status' => 'saved',
        ]);

        return response()->json([
            'message' => 'Generation linked to quiz successfully.',
            'generation_id' => $generation->id,
            'quiz_id' => $quiz->id,
        ]);
    }

    /**
     * Get generation history for admin
     *
     * GET /admin/v1/quizzes/ai/history
     */
    public function history(Request $request)
    {
        Gate::authorize('quizzes.view');

        $generations = QuizGeneration::where('admin_id', $request->user()->id)
            ->with('quiz:id,title,status')
            ->orderByDesc('created_at')
            ->paginate(15);

        return response()->json($generations);
    }

    /**
     * Delete a generation record
     *
     * DELETE /admin/v1/quizzes/ai/{generation}
     */
    public function destroyGeneration(QuizGeneration $generation)
    {
        Gate::authorize('quizzes.delete');

        if ($generation->quiz_id && $generation->quiz) {
            return response()->json([
                'message' => 'Cannot delete a generation that is linked to a quiz. Delete the quiz instead.',
            ], 422);
        }

        $generation->delete();

        return response()->json(['message' => 'Generation record deleted successfully.']);
    }
}
