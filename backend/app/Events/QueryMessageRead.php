<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class QueryMessageRead implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public int $queryId;
    public string $readerType;
    public string $readAt;
    public int $unreadCount;

    public function __construct(int $queryId, string $readerType, int $unreadCount)
    {
        $this->queryId = $queryId;
        $this->readerType = $readerType;
        $this->readAt = now()->toISOString();
        $this->unreadCount = $unreadCount;
    }

    public function broadcastOn(): PrivateChannel
    {
        return new PrivateChannel("query.{$this->queryId}");
    }

    public function broadcastAs(): string
    {
        return 'QueryMessageRead';
    }

    public function broadcastWith(): array
    {
        return [
            'query_id' => $this->queryId,
            'reader_type' => $this->readerType,
            'read_at' => $this->readAt,
            'unread_count' => $this->unreadCount,
        ];
    }
}
