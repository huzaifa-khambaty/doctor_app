<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Domain\Shared\Models\Query;
use App\Domain\Shared\Models\QueryMessage;

class QueryMessageSeeder extends Seeder
{
    public function run(): void
    {
        Query::whereNotNull('message')->chunk(100, function ($queries) {
            foreach ($queries as $query) {
                // Doctor's original message
                $msg = QueryMessage::create([
                    'query_id' => $query->id,
                    'sender_type' => 'doctor',
                    'sender_id' => $query->user_id,
                    'message' => $query->message,
                    'created_at' => $query->created_at,
                    'updated_at' => $query->created_at,
                ]);

                // Admin's response (if exists)
                if ($query->admin_response) {
                    QueryMessage::create([
                        'query_id' => $query->id,
                        'sender_type' => 'admin',
                        'sender_id' => $query->responded_by,
                        'message' => $query->admin_response,
                        'created_at' => $query->responded_at ?? $query->updated_at,
                        'updated_at' => $query->responded_at ?? $query->updated_at,
                        'read_at' => $query->responded_at,
                    ]);
                }

                // Update query timestamps
                $query->update([
                    'last_message_at' => $query->responded_at ?? $query->created_at,
                    'doctor_read_at' => $query->responded_at ? $query->created_at : null,
                    'admin_read_at' => $query->responded_at ?? null,
                ]);
            }
        });
    }
}
