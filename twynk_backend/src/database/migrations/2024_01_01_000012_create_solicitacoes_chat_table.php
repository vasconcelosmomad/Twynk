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
        Schema::create('solicitacoes_chat', function (Blueprint $table) {
            $table->id();
            $table->foreignId('solicitante_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('solicitado_id')->constrained('users')->onDelete('cascade');
            $table->enum('tipo', ['chat', 'video']);
            $table->enum('status', ['pendente', 'aceito', 'recusado'])->default('pendente');
            $table->timestamp('data_solicitacao')->useCurrent();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('solicitacoes_chat');
    }
};

