<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('quizzes', function (Blueprint $table) {
            // Remove the old topic string column
            if (Schema::hasColumn('quizzes', 'topic')) {
                $table->dropColumn('topic');
            }
            // Add topic_id foreign key
            $table->foreignId('topic_id')
                ->nullable()
                ->constrained('topics')
                ->nullOnDelete()
                ->after('title');
        });
    }

    public function down(): void
    {
        Schema::table('quizzes', function (Blueprint $table) {
            $table->dropForeign(['topic_id']);
            $table->dropColumn('topic_id');
            $table->string('topic')->nullable()->after('title');
        });
    }
};