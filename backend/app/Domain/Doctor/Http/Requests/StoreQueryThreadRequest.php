<?php

namespace App\Domain\Doctor\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreQueryThreadRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'category_id' => 'required|integer|exists:query_categories,id',
            'subject' => 'required|string|max:255',
            'message' => 'required|string',
            'attachments.*' => 'nullable|file|max:10240',
        ];
    }
}
