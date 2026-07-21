<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('content_library', function (Blueprint $table) {
            $table->unsignedBigInteger('pdf_size')->nullable()->after('pdf_path');
        });
    }

    public function down(): void
    {
        Schema::table('content_library', function (Blueprint $table) {
            $table->dropColumn('pdf_size');
        });
    }
};
