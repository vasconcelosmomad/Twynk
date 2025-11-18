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
        Schema::create('likes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_usuario_origem')->constrained('users')->onDelete('cascade');
            $table->foreignId('id_usuario_destino')->constrained('users')->onDelete('cascade');
            $table->timestamp('data_like')->useCurrent();
            $table->unique(['id_usuario_origem', 'id_usuario_destino']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('likes');
    }
};

