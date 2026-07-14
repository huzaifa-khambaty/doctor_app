<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('conference_agenda_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('conference_detail_id')->constrained('conference_details')->cascadeOnDelete();
            $table->integer('day')->nullable();
            $table->string('time')->nullable();
            $table->string('title');
            $table->text('description')->nullable();
            $table->string('location')->nullable();
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('conference_agenda_items');
    }
};
