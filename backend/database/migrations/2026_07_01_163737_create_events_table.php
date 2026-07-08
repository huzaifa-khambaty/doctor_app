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
        Schema::create('events', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->enum('type', ['webinar', 'conference', 'workshop']);
            $table->string('speaker')->nullable();
            $table->timestamp('starts_at');
            $table->timestamp('ends_at')->nullable();
            $table->string('timezone')->default('UTC');
            $table->string('location')->nullable();
            $table->text('description');
            $table->string('banner_path')->nullable();
            $table->string('external_join_link')->nullable();
            $table->string('recording_link')->nullable();
            $table->enum('status', ['draft', 'review', 'published', 'unpublished'])->default('draft');
            $table->foreignId('created_by')->constrained('admins')->cascadeOnDelete();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('events');
    }
};
