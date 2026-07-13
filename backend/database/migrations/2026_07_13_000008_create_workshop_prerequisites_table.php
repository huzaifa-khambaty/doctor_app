<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('workshop_prerequisites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workshop_detail_id')->constrained('workshop_details')->cascadeOnDelete();
            $table->text('prerequisite');
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('workshop_prerequisites');
    }
};
