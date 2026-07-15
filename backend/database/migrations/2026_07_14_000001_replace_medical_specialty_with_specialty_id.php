<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Migrate data from medical_specialty_id to specialty_id where specialty_id is null
        DB::table('users')
            ->whereNull('specialty_id')
            ->whereNotNull('medical_specialty_id')
            ->update(['specialty_id' => DB::raw('medical_specialty_id')]);

        Schema::table('users', function (Blueprint $table) {
            $table->foreign('specialty_id')->references('id')->on('specialties')->nullOnDelete();
            $table->dropForeign(['medical_specialty_id']);
            $table->dropColumn('medical_specialty_id');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('medical_specialty_id')->nullable()->after('specialty_id')->constrained('specialties')->nullOnDelete();
            $table->dropForeign(['specialty_id']);
            $table->dropColumn('specialty_id');
        });

        // Migrate data back
        DB::table('users')
            ->whereNull('medical_specialty_id')
            ->whereNotNull('specialty_id')
            ->update(['specialty_id' => DB::raw('medical_specialty_id')]);
    }
};
