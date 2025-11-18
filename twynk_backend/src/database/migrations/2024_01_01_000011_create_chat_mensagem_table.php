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
        Schema::create('chat_mensagem', function (Blueprint $table) {
            $table->id();
            $table->string('chat_id', 100);
            $table->foreignId('remetente_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('destinatario_id')->constrained('users')->onDelete('cascade');
            $table->enum('tipo', ['texto', 'imagem', 'audio', 'video'])->default('texto');
            $table->text('conteudo')->nullable();
            $table->timestamp('data_envio')->useCurrent();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('chat_mensagem');
    }
};

