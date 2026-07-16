<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('badges', function (Blueprint $table) {
            $table->foreignId('category_id')->nullable()->after('icon_path')
                  ->constrained('badge_categories')->nullOnDelete();
        });

        // Assign categories to existing badges
        $quizMasteryId = DB::table('badge_categories')->where('name', 'Quiz Mastery')->first()?->id;
        $engagementId = DB::table('badge_categories')->where('name', 'Engagement')->first()?->id;

        if ($quizMasteryId) {
            DB::table('badges')->whereIn('code', [
                'first_quiz', 'perfect_score', 'streak_5', 'top_3', 'fast_learner', 'expert'
            ])->update(['category_id' => $quizMasteryId]);
        }

        if ($engagementId) {
            DB::table('badges')->where('code', 'event_regular')
              ->update(['category_id' => $engagementId]);
        }
    }

    public function down(): void
    {
        Schema::table('badges', function (Blueprint $table) {
            $table->dropForeign(['category_id']);
            $table->dropColumn('category_id');
        });
    }
};
