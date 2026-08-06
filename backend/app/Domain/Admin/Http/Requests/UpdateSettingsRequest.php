<?php

namespace App\Domain\Admin\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateSettingsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'app_name' => 'sometimes|required|string|max:255',
            'app_email' => 'sometimes|required|email|max:255',
            'app_logo' => 'nullable|image|mimes:svg,png,jpg|max:2048',
            'time_zone' => 'sometimes|required|string|in:UTC,EST,PST,GMT',
            'language' => 'sometimes|required|string|in:en,es,fr,de',
        ];
    }

    public function messages(): array
    {
        return [
            'app_name.required' => 'App name is required.',
            'app_name.max' => 'App name must not exceed 255 characters.',
            'app_email.required' => 'Support email is required.',
            'app_email.email' => 'Please provide a valid email address.',
            'app_logo.image' => 'Logo must be an image file.',
            'app_logo.mimes' => 'Logo must be SVG, PNG, or JPG format.',
            'app_logo.max' => 'Logo size must not exceed 2MB.',
            'time_zone.required' => 'Timezone is required.',
            'time_zone.in' => 'Please select a valid timezone.',
            'language.required' => 'Language is required.',
            'language.in' => 'Please select a valid language.',
        ];
    }
}
