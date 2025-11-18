<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (!Schema::hasTable('cidade')) {
            Schema::create('cidade', function (Blueprint $table) {
                $table->id();
                $table->string('nome', 100);
                $table->foreignId('provincia_id')->constrained('provincia')->cascadeOnDelete();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasTable('cidade')) {
            Schema::dropIfExists('cidade');
        }
    }
};
