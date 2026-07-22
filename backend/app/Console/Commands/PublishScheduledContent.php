<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Domain\Shared\Models\ContentLibrary;
use Illuminate\Support\Facades\Log;

class PublishScheduledContent extends Command
{
    protected $signature = 'content:publish-scheduled';

    protected $description = 'Automatically publish content whose scheduled_at time has arrived.';

    public function handle()
    {
        $contents = ContentLibrary::where('status', '!=', 'published')
            ->whereNotNull('scheduled_at')
            ->where('scheduled_at', '<=', now())
            ->get();

        if ($contents->isEmpty()) {
            $this->info('No scheduled content to publish.');
            return;
        }

        foreach ($contents as $content) {
            try {
                $content->update([
                    'status' => 'published',
                    'published_at' => $content->published_at ?? now(),
                ]);

                $this->info("Published content ID: {$content->id} — {$content->title}");
            } catch (\Exception $e) {
                Log::error("Failed to publish content {$content->id}: " . $e->getMessage());
                $this->error("Failed to publish content {$content->id}");
            }
        }

        $this->info('Finished publishing scheduled content.');
    }
}
