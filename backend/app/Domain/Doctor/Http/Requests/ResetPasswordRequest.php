<?php

namespace App\Domain\Doctor\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ResetPasswordRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'identifier' => 'required|string',
            'code' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ];
    }
}
