<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('article_images', function (Blueprint $table) {
            $table->id();
            $table->foreignId('content_library_id')->constrained('content_library')->cascadeOnDelete();
            $table->string('path');
            $table->string('filename');
            $table->string('mime_type')->nullable();
            $table->bigInteger('size');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('article_images');
    }
};
