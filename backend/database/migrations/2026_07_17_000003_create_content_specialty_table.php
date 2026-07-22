<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('content_specialty', function (Blueprint $table) {
            $table->id();
            $table->foreignId('content_id')->constrained('content_library')->cascadeOnDelete();
            $table->foreignId('specialty_id')->constrained('specialties')->cascadeOnDelete();
            $table->timestamps();
            $table->unique(['content_id', 'specialty_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('content_specialty');
    }
};
