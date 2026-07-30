<?php

namespace App\Domain\Shared\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SendQueryMessageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'message' => 'required_without:attachments|string',
            'attachments.*' => 'nullable|file|max:10240',
        ];
    }
}
