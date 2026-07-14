<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('webinar_details', function (Blueprint $table) {
            $table->id();
            $table->foreignId('event_id')->constrained('events')->cascadeOnDelete()->unique();
            $table->string('speaker_designation')->nullable();
            $table->decimal('cme_credits', 5, 2)->default(0);
            $table->string('format')->nullable();
            $table->text('syllabus')->nullable();
            $table->decimal('registration_fee', 10, 2)->default(0);
            $table->string('currency', 3)->default('USD');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('webinar_details');
    }
};
