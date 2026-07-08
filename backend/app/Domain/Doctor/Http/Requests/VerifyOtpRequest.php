<?php

namespace App\Domain\Doctor\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class VerifyOtpRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'identifier' => 'required|string',
            'channel' => 'required|in:email,phone',
            'code' => 'required|string',
            'purpose' => 'required|in:register,login,reset',
        ];
    }
}
