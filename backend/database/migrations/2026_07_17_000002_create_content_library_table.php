<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('content_library', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->foreignId('type_id')->constrained('content_types')->cascadeOnDelete();
            $table->longText('description')->nullable();
            $table->string('thumbnail_path')->nullable();
            $table->string('pdf_path')->nullable();
            $table->string('content_link')->nullable();
            $table->foreignId('quiz_id')->nullable()->constrained('quizzes')->nullOnDelete();
            $table->foreignId('webinar_id')->nullable()->constrained('events')->nullOnDelete();
            $table->enum('status', ['draft', 'in_review', 'published'])->default('draft');
            $table->timestamp('published_at')->nullable();
            $table->timestamp('scheduled_at')->nullable();
            $table->integer('views_count')->default(0);
            $table->integer('likes_count')->default(0);
            $table->foreignId('created_by')->constrained('admins')->cascadeOnDelete();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('content_library');
    }
};
