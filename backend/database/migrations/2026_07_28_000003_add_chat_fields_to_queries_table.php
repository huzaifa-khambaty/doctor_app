<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('queries', function (Blueprint $table) {
            $table->enum('status', ['open', 'in_progress', 'resolved', 'closed'])->default('open')->change();
            $table->timestamp('last_message_at')->nullable()->after('status');
            $table->timestamp('doctor_read_at')->nullable()->after('last_message_at');
            $table->timestamp('admin_read_at')->nullable()->after('doctor_read_at');
        });
    }

    public function down(): void
    {
        Schema::table('queries', function (Blueprint $table) {
            $table->enum('status', ['pending', 'answered', 'closed'])->default('pending')->change();
            $table->dropColumn(['last_message_at', 'doctor_read_at', 'admin_read_at']);
        });
    }
};
