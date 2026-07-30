<?php

namespace App\Events;

use App\Domain\Shared\Models\QueryMessage;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class QueryMessageSent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $message;
    public $queryId;

    public function __construct(QueryMessage $message)
    {
        $this->message = $message->load('attachments', 'sender');
        $this->queryId = $message->query_id;
    }

    public function broadcastOn(): PrivateChannel
    {
        return new PrivateChannel("query.{$this->queryId}");
    }

    public function broadcastAs(): string
    {
        return 'QueryMessageSent';
    }

    public function broadcastWith(): array
    {
        return [
            'message' => [
                'id' => $this->message->id,
                'query_id' => $this->message->query_id,
                'sender_type' => $this->message->sender_type,
                'sender_id' => $this->message->sender_id,
                'sender' => [
                    'id' => $this->message->sender->id,
                    'name' => $this->message->sender_type === 'doctor'
                        ? $this->message->sender->full_name
                        : $this->message->sender->name,
                ],
                'message' => $this->message->message,
                'attachments' => $this->message->attachments->map(fn ($a) => [
                    'id' => $a->id,
                    'original_name' => $a->original_name,
                    'mime_type' => $a->mime_type,
                    'size' => $a->size,
                    'url' => $a->url,
                ]),
                'created_at' => $this->message->created_at,
            ],
        ];
    }
}
