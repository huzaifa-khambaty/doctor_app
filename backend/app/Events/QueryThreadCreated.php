<?php

namespace App\Events;

use App\Domain\Shared\Models\Query;
use App\Domain\Shared\Models\QueryMessage;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class QueryThreadCreated implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $query;
    public $firstMessage;

    public function __construct(Query $query, QueryMessage $firstMessage)
    {
        $this->query = $query->load('category:id,name,slug', 'user:id,full_name');
        $this->firstMessage = $firstMessage->load('attachments');
    }

    public function broadcastOn(): array
    {
        return [
            new PrivateChannel("query.{$this->query->id}"),
            new PrivateChannel('admin.queries'),
        ];
    }

    public function broadcastAs(): string
    {
        return 'QueryThreadCreated';
    }

    public function broadcastWith(): array
    {
        return [
            'query' => [
                'id' => $this->query->id,
                'subject' => $this->query->subject,
                'status' => $this->query->status,
                'category' => $this->query->category,
                'user' => $this->query->user,
                'created_at' => $this->query->created_at,
            ],
            'first_message' => [
                'id' => $this->firstMessage->id,
                'message' => $this->firstMessage->message,
                'sender_type' => $this->firstMessage->sender_type,
                'sender_id' => $this->firstMessage->sender_id,
                'attachments' => $this->firstMessage->attachments,
                'created_at' => $this->firstMessage->created_at,
            ],
        ];
    }
}
