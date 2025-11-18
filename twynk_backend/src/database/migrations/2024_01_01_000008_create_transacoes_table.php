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
        Schema::create('transacoes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('usuario_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('plano_id')->nullable()->constrained('planos');
            $table->decimal('valor_pago', 10, 2);
            $table->enum('metodo_pagamento', ['mpesa', 'emola', 'paypal', 'stripe', 'outro'])->default('mpesa');
            $table->timestamp('data_pagamento')->useCurrent();
            $table->enum('status', ['pago', 'pendente', 'falhou'])->default('pago');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transacoes');
    }
};

