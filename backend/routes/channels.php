<?php

use Illuminate\Support\Facades\Broadcast;
use App\Domain\Shared\Models\Query;

Broadcast::channel('query.{queryId}', function ($user, $queryId) {
    $query = Query::find($queryId);

    if (!$query) {
        return false;
    }

    // Doctor owns the query OR user is admin
    return $query->user_id === $user->id || $user->hasAbility('admin');
});

Broadcast::channel('admin.queries', function ($user) {
    return $user->hasAbility('admin');
});
