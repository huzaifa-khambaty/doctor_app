<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('message');
            $table->string('audience_segment')->default('all_users');
            $table->enum('status', ['draft', 'scheduled', 'published'])->default('draft');
            $table->timestamp('schedule_at')->nullable();
            $table->timestamp('sent_at')->nullable();
            $table->integer('estimated_recipients')->default(0);
            $table->foreignId('created_by')->constrained('admins');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
