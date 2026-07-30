<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('query_messages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('query_id')->constrained('queries')->onDelete('cascade');
            $table->enum('sender_type', ['doctor', 'admin']);
            $table->unsignedBigInteger('sender_id');
            $table->text('message')->nullable();
            $table->timestamp('read_at')->nullable();
            $table->timestamps();

            $table->index(['query_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('query_messages');
    }
};
