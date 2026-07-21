<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('content_external_links', function (Blueprint $table) {
            $table->id();
            $table->foreignId('content_id')->constrained('content_library')->cascadeOnDelete();
            $table->string('url');
            $table->string('label')->nullable();
            $table->integer('display_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('content_external_links');
    }
};
