<?php

namespace App\Domain\Admin\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreNotificationRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'title' => 'required|string|max:150',
            'message' => 'required|string|max:1000',
            'audience_segment' => 'required|string|in:all_users,verified,pending',
            'schedule_at' => 'nullable|date|after:now',
            'status' => 'required|string|in:draft,scheduled,published',
        ];
    }

    public function messages(): array
    {
        return [
            'title.required' => 'The title field is required.',
            'title.max' => 'The title must not exceed 150 characters.',
            'message.required' => 'The message field is required.',
            'message.max' => 'The message must not exceed 1000 characters.',
            'audience_segment.required' => 'The audience segment field is required.',
            'audience_segment.in' => 'The audience segment must be all_users, verified, or pending.',
            'schedule_at.after' => 'The scheduled date must be in the future.',
            'status.required' => 'The status field is required.',
            'status.in' => 'The status must be draft, scheduled, or published.',
        ];
    }
}
