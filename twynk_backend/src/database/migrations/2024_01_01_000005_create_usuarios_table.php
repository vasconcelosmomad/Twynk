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
            // Dados básicos
            $table->string('nome', 100);
            $table->string('apelido', 100)->nullable();
            $table->enum('genero', ['Homem', 'Mulher', 'outro'])->default('outro');
            $table->string('sexualidade', 50)->nullable();
            $table->enum('interesse', ['Homem', 'Mulher', 'Ambos'])->default('Ambos');
            $table->string('estado_civil', 50)->nullable();
            $table->date('data_nascimento');
            $table->string('signo', 50)->nullable();
            $table->string('email', 150)->unique();
            $table->string('password', 255)->nullable(); // nulo se registro via Google
            $table->string('google_id', 255)->nullable()->unique(); // nulo se registro via email
            $table->boolean('is_verified')->default(false);
            $table->boolean('is_banned')->default(false);
            $table->string('motivo_banamento', 255)->nullable();
            $table->timestamp('ultimo_login')->nullable();
            $table->string('role', 50)->default('user');
            $table->string('foto_perfil', 255)->nullable();
            $table->text('bio')->nullable();
            $table->string('localizacao', 255)->nullable();

            // Preferências de relacionamento / busca
            $table->string('tipo_relacionamento', 50)->nullable();
            $table->string('busca_genero', 50)->nullable();
            $table->unsignedTinyInteger('busca_idade_min')->nullable();
            $table->unsignedTinyInteger('busca_idade_max')->nullable();
            $table->unsignedSmallInteger('busca_distancia')->nullable();

            // Dados pessoais adicionais
            $table->unsignedTinyInteger('filhos')->nullable();
            $table->string('escolaridade', 100)->nullable();
            $table->string('profissao', 150)->nullable();
            $table->string('religiao', 100)->nullable();
            $table->string('humor', 100)->nullable();

            // Localização normalizada (referências opcionais, FKs adicionadas em migration posterior)
            $table->unsignedBigInteger('pais_id')->nullable();
            $table->unsignedBigInteger('provincia_id')->nullable();
            $table->unsignedBigInteger('cidade_id')->nullable();
            $table->string('mora_com', 100)->nullable();

            // Aparência física
            $table->string('cor_pele', 50)->nullable();
            $table->string('cor_olhos', 50)->nullable();
            $table->string('cor_cabelos', 50)->nullable();
            $table->float('altura')->nullable();
            $table->float('peso')->nullable();

            // Hábitos e estilo de vida
            $table->boolean('pratica_esporte')->nullable();
            $table->boolean('fuma')->nullable();
            $table->boolean('bebe')->nullable();
            $table->text('como_me_considero_fisicamente')->nullable();

            // Coordenadas de GPS
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();

            // Status e plano
            $table->enum('status', ['ativo', 'inativo', 'banido'])->default('ativo');
            $table->foreignId('plano_id')->nullable()->constrained('planos');
            $table->timestamp('plano_expira_em')->nullable();
            $table->integer('limite_solicitacoes')->nullable();

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

