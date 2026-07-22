<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('content_library', function (Blueprint $table) {
            $table->dropForeign(['webinar_id']);
            $table->dropColumn('webinar_id');
            $table->string('webinar_path')->nullable()->after('quiz_id');
            $table->unsignedInteger('downloads_count')->default(0)->after('views_count');
        });
    }

    public function down(): void
    {
        Schema::table('content_library', function (Blueprint $table) {
            $table->dropColumn(['webinar_path', 'downloads_count']);
            $table->foreignId('webinar_id')->nullable()->constrained('events')->nullOnDelete();
        });
    }
};
