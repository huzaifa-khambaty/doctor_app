<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('quiz_attempt_answer_options', function (Blueprint $table) {
            $table->id();
            $table->foreignId('quiz_attempt_answer_id')
                ->constrained('quiz_attempt_answers')
                ->cascadeOnDelete()
                ->name('q_att_ans_opt_attempt_answer_id_foreign');
            $table->foreignId('quiz_option_id')
                ->constrained('quiz_options')
                ->cascadeOnDelete()
                ->name('q_att_ans_opt_option_id_foreign');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('quiz_attempt_answer_options');
    }
};
