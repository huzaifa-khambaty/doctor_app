<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureDoctorAbility
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (!$request->user() || !$request->user()->tokenCan('doctor')) {
            return response()->json(['message' => 'Unauthorized.'], 403);
        }

        if (in_array($request->user()->status, ['suspended', 'rejected'])) {
            return response()->json(['message' => 'Account is ' . $request->user()->status . '.'], 403);
        }

        return $next($request);
    }
}
