<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Require Verified to Attempt
    |--------------------------------------------------------------------------
    |
    | If this is true, only doctors with a status of 'verified' can start or
    | submit quiz attempts. Pending, rejected, or suspended doctors will
    | receive a 403 Forbidden response.
    |
    */
    'require_verified_to_attempt' => true,
];
