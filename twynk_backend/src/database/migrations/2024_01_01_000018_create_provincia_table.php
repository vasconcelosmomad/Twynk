<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('provincia')) {
            Schema::create('provincia', function (Blueprint $table) {
                $table->id();
                $table->string('nome', 100);
                $table->foreignId('pais_id')->constrained('pais')->cascadeOnDelete();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('provincia')) {
            Schema::dropIfExists('provincia');
        }
    }
};
