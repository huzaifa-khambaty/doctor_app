<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('medical_specialty_id')->nullable()->after('specialty_id')->constrained('specialties')->nullOnDelete();
            $table->string('license_number', 100)->nullable()->after('medical_specialty_id');
            $table->string('hospital_clinic_affiliation', 255)->nullable()->after('license_number');
            $table->year('year_of_registration')->nullable()->after('hospital_clinic_affiliation');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['medical_specialty_id']);
            $table->dropColumn(['medical_specialty_id', 'license_number', 'hospital_clinic_affiliation', 'year_of_registration']);
        });
    }
};
