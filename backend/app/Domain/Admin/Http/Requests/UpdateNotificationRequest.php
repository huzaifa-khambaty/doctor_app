<?php

namespace App\Domain\Admin\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateNotificationRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => 'sometimes|required|string|max:150',
            'message' => 'sometimes|required|string|max:1000',
            'audience_segment' => 'sometimes|required|string|in:all_users,verified,pending',
            'schedule_at' => 'nullable|date|after:now',
            'status' => 'sometimes|required|in:draft,scheduled,published',
        ];
    }

    public function messages(): array
    {
        return [
            'title.max' => 'The title must not exceed 150 characters.',
            'message.max' => 'The message must not exceed 1000 characters.',
            'audience_segment.in' => 'The audience segment must be all_users, verified, or pending.',
            'schedule_at.after' => 'The scheduled date must be in the future.',
            'status.in' => 'The status must be draft, scheduled, or published.',
        ];
    }
}
