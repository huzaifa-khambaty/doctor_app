<?php

namespace App\Domain\Shared\Http\Controllers\Api;

use App\Domain\Shared\Models\Specialty;
use Illuminate\Routing\Controller;

class SpecialtyController extends Controller
{
    public function index()
    {
        $specialties = Specialty::select('id', 'name', 'slug')->orderBy('name')->get();
        return response()->json($specialties);
    }
}
