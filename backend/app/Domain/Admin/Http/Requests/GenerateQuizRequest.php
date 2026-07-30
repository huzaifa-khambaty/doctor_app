<?php

namespace App\Domain\Admin\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class GenerateQuizRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        $maxQuestions = config('openai.max_questions_per_generation', 50);

        return [
            'topic' => 'nullable|string|max:255',
            'prompt' => 'required|string|max:2000',
            'question_count' => "nullable|integer|min:1|max:{$maxQuestions}",
            'difficulty' => 'nullable|in:easy,medium,hard',
            'question_types' => 'nullable|array',
            'question_types.*' => 'in:single,multiple',
            'document' => 'nullable|file|mimes:pdf,doc,docx,txt|max:10240',
        ];
    }

    public function messages(): array
    {
        return [
            'prompt.required' => 'Please provide instructions for quiz generation.',
            'question_count.min' => 'At least 1 question is required.',
            'question_count.max' => 'Maximum 50 questions per generation.',
            'difficulty.in' => 'Difficulty must be easy, medium, or hard.',
            'question_types.*.in' => 'Question types must be single or multiple.',
            'document.mimes' => 'Document must be a PDF, Word document, or text file.',
            'document.max' => 'Document size must not exceed 10MB.',
        ];
    }
}
