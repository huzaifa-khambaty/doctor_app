<?php

namespace App\Domain\Doctor\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterDoctorRequest extends FormRequest
{
    public function authorize()
    {
        return true;
    }

    public function rules()
    {
        return [
            'full_name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'phone' => 'required|string|unique:users,phone',
            'specialty_id' => 'nullable|exists:specialties,id',
            'specialties' => 'required|array',
            'specialties.*' => 'exists:specialties,id',
            'hospital_affiliation' => 'required|string|max:255',
            'password' => 'required|string|min:8|confirmed',
        ];
    }
}
