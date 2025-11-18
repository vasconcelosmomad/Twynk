<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Mídia
            $table->json('foto_galeria')->nullable()->after('foto_perfil');

            // Localização detalhada
            $table->decimal('latitude', 10, 7)->nullable()->after('localizacao');
            $table->decimal('longitude', 10, 7)->nullable()->after('latitude');

            // Plano / limites
            $table->timestamp('plano_expira_em')->nullable()->after('plano_id');
            $table->unsignedInteger('limite_solicitacoes')->nullable()->after('plano_expira_em');

            // Preferências
            $table->string('tipo_relacionamento', 50)->nullable()->after('role');
            $table->enum('busca_genero', ['masculino', 'feminino', 'ambos'])->nullable()->after('tipo_relacionamento');
            $table->unsignedTinyInteger('busca_idade_min')->nullable()->after('busca_genero');
            $table->unsignedTinyInteger('busca_idade_max')->nullable()->after('busca_idade_min');
            $table->unsignedSmallInteger('busca_distancia')->nullable()->after('busca_idade_max');

            // Dados pessoais opcionais
            $table->unsignedSmallInteger('altura')->nullable()->after('busca_distancia'); // em cm
            $table->unsignedSmallInteger('peso')->nullable()->after('altura'); // em kg
            $table->string('estado_civil', 50)->nullable()->after('peso');

            // Segurança e controle
            $table->boolean('is_banned')->default(false)->after('is_verified');
            $table->string('motivo_banimento', 255)->nullable()->after('is_banned');
            $table->timestamp('ultimo_login')->nullable()->after('motivo_banimento');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'foto_galeria',
                'latitude',
                'longitude',
                'plano_expira_em',
                'limite_solicitacoes',
                'tipo_relacionamento',
                'busca_genero',
                'busca_idade_min',
                'busca_idade_max',
                'busca_distancia',
                'altura',
                'peso',
                'estado_civil',
                'is_banned',
                'motivo_banimento',
                'ultimo_login',
            ]);
        });
    }
};
