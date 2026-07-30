<?php

return [
    'model' => env('OPENAI_MODEL', 'gpt-4o'),
    'max_tokens' => env('OPENAI_MAX_TOKENS', 4000),
    'temperature' => env('OPENAI_TEMPERATURE', 0.7),
    'max_questions_per_generation' => env('OPENAI_MAX_QUESTIONS', 50),
];
