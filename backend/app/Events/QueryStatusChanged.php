<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class QueryStatusChanged implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public int $queryId;
    public string $status;
    public int $updatedBy;

    public function __construct(int $queryId, string $status, int $updatedBy)
    {
        $this->queryId = $queryId;
        $this->status = $status;
        $this->updatedBy = $updatedBy;
    }

    public function broadcastOn(): array
    {
        return [
            new PrivateChannel("query.{$this->queryId}"),
            new PrivateChannel('admin.queries'),
        ];
    }

    public function broadcastAs(): string
    {
        return 'QueryStatusChanged';
    }

    public function broadcastWith(): array
    {
        return [
            'query_id' => $this->queryId,
            'status' => $this->status,
            'updated_by' => $this->updatedBy,
        ];
    }
}
