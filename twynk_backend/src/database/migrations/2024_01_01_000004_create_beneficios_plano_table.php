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
        Schema::create('beneficios_plano', function (Blueprint $table) {
            $table->id();
            $table->foreignId('plano_id')->constrained('planos')->onDelete('cascade');
            $table->integer('curtidas_dia')->default(0);
            $table->integer('mensagens_dia')->default(0);
            $table->integer('video_tempo_min')->default(0);
            $table->integer('boost_semana')->default(0);
            $table->boolean('pode_chat')->default(false);
            $table->boolean('pode_video')->default(false);
            $table->boolean('ver_quem_curtiu')->default(false);
            $table->boolean('enviar_fotos')->default(false);
            $table->decimal('creditos_iniciais', 10, 2)->default(0);
            $table->boolean('suporte_prioritario')->default(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('beneficios_plano');
    }
};

