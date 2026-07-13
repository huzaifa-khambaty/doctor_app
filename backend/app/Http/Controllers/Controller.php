<?php

namespace App\Http\Controllers;

use Illuminate\Pagination\LengthAwarePaginator;

abstract class Controller
{
    protected function jsonWithPagination(LengthAwarePaginator $paginator, $data = null, string $wrap = null)
    {
        $response = [];

        if ($wrap) {
            $response[$wrap] = $data ?? $paginator->items();
        } else {
            $response['data'] = $data ?? $paginator->items();
        }

        $response['pagination'] = [
            'page' => $paginator->currentPage(),
            'per_page' => $paginator->perPage(),
            'total' => $paginator->total(),
            'last_page' => $paginator->lastPage(),
            'has_next' => $paginator->hasMorePages(),
            'has_previous' => $paginator->currentPage() > 1,
        ];

        return response()->json($response, 200);
    }
}
