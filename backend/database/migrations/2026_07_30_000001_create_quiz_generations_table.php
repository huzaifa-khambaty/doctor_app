<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('quiz_generations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('admin_id')->constrained('admins')->cascadeOnDelete();
            $table->string('topic');
            $table->text('prompt');
            $table->string('document_filename')->nullable();
            $table->string('document_path')->nullable();
            $table->json('generation_params')->nullable();
            $table->json('generated_questions');
            $table->json('saved_questions')->nullable();
            $table->enum('status', ['generated', 'previewed', 'saved', 'discarded'])->default('generated');
            $table->foreignId('quiz_id')->nullable()->constrained('quizzes')->nullOnDelete();
            $table->timestamps();

            $table->index(['admin_id', 'created_at']);
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('quiz_generations');
    }
};
