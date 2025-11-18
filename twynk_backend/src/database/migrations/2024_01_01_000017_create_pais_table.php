<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('pais')) {
            Schema::create('pais', function (Blueprint $table) {
                $table->id();
                $table->string('nome', 100)->unique();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('pais')) {
            Schema::dropIfExists('pais');
        }
    }
};
