<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('webinar_learning_objectives', function (Blueprint $table) {
            $table->id();
            $table->foreignId('webinar_detail_id')->constrained('webinar_details')->cascadeOnDelete();
            $table->text('objective');
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('webinar_learning_objectives');
    }
};
