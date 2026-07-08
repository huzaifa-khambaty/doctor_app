<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Domain\Shared\Models\Quiz;
use App\Domain\Shared\Services\BadgeAwardService;
use Illuminate\Support\Facades\Log;

class FinalizeClosedQuizzes extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'quiz:finalize';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Find published quizzes that have closed, mark them closed, and award top 3 badges.';

    /**
     * Execute the console command.
     */
    public function handle(BadgeAwardService $badgeService)
    {
        $quizzes = Quiz::where('status', 'published')
            ->whereNotNull('closes_at')
            ->where('closes_at', '<', now())
            ->get();

        if ($quizzes->isEmpty()) {
            $this->info('No newly closed quizzes to finalize.');
            return;
        }

        foreach ($quizzes as $quiz) {
            try {
                $quiz->update(['status' => 'closed']);
                
                // Award top 3 badges
                $badgeService->evaluateTop3($quiz);

                $this->info("Finalized quiz ID: {$quiz->id}");
            } catch (\Exception $e) {
                Log::error("Failed to finalize quiz {$quiz->id}: " . $e->getMessage());
                $this->error("Failed to finalize quiz {$quiz->id}");
            }
        }

        $this->info('Finished finalization process.');
    }
}
