<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('visualizacoes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_visualizador')->constrained('users')->onDelete('cascade');
            $table->foreignId('id_visualizado')->constrained('users')->onDelete('cascade');
            $table->timestamp('data_visualizacao')->useCurrent();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('visualizacoes');
    }
};

