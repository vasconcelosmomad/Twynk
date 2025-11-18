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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('nome', 100);
            $table->enum('genero', ['masculino', 'feminino', 'outro'])->default('outro');
            $table->enum('interesse', ['masculino', 'feminino', 'ambos'])->default('ambos');
            $table->date('data_nascimento');
            $table->string('email', 150)->unique();
            $table->string('password', 255)->nullable(); // nulo se registro via Google
            $table->string('google_id', 255)->nullable()->unique(); // nulo se registro via email
            $table->string('foto_perfil', 255)->nullable();
            $table->text('bio')->nullable();
            $table->string('localizacao', 255)->nullable();
            $table->enum('status', ['ativo', 'inativo', 'banido'])->default('ativo');
            $table->foreignId('plano_id')->nullable()->constrained('planos');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};

