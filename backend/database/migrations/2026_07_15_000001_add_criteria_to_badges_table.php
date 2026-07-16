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
            $table->string('criteria_type')->nullable()->after('description');
            $table->integer('criteria_value')->nullable()->after('criteria_type');
            $table->boolean('is_active')->default(true)->after('criteria_value');
        });

        // Populate criteria for existing badges
        DB::table('badges')->where('code', 'first_quiz')->update([
            'criteria_type' => 'quiz_completed',
            'criteria_value' => 1,
        ]);
        DB::table('badges')->where('code', 'perfect_score')->update([
            'criteria_type' => 'perfect_score',
            'criteria_value' => 1,
        ]);
        DB::table('badges')->where('code', 'streak_5')->update([
            'criteria_type' => 'quiz_streak',
            'criteria_value' => 5,
        ]);
        DB::table('badges')->where('code', 'top_3')->update([
            'criteria_type' => 'leaderboard_rank',
            'criteria_value' => 3,
        ]);
    }

    public function down(): void
    {
        Schema::table('badges', function (Blueprint $table) {
            $table->dropColumn(['criteria_type', 'criteria_value', 'is_active']);
        });
    }
};
