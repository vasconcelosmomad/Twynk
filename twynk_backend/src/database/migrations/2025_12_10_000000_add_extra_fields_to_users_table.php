<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Dados básicos extras (somente se ainda não existirem)
            if (!Schema::hasColumn('users', 'apelido')) {
                $table->string('apelido', 100)->nullable()->after('nome');
            }
            if (!Schema::hasColumn('users', 'sexualidade')) {
                $table->string('sexualidade', 50)->nullable()->after('genero');
            }
            if (!Schema::hasColumn('users', 'estado_civil')) {
                $table->string('estado_civil', 50)->nullable()->after('interesse');
            }
            if (!Schema::hasColumn('users', 'signo')) {
                $table->string('signo', 50)->nullable()->after('data_nascimento');
            }
            if (!Schema::hasColumn('users', 'is_verified')) {
                $table->boolean('is_verified')->default(false)->after('google_id');
            }
            if (!Schema::hasColumn('users', 'is_banned')) {
                $table->boolean('is_banned')->default(false)->after('is_verified');
            }
            if (!Schema::hasColumn('users', 'motivo_banamento')) {
                $table->string('motivo_banamento', 255)->nullable()->after('is_banned');
            }
            if (!Schema::hasColumn('users', 'ultimo_login')) {
                $table->timestamp('ultimo_login')->nullable()->after('motivo_banamento');
            }
            if (!Schema::hasColumn('users', 'role')) {
                $table->string('role', 50)->default('user')->after('ultimo_login');
            }

            // Preferências de relacionamento / busca
            if (!Schema::hasColumn('users', 'tipo_relacionamento')) {
                $table->string('tipo_relacionamento', 50)->nullable()->after('localizacao');
            }
            if (!Schema::hasColumn('users', 'busca_genero')) {
                $table->string('busca_genero', 50)->nullable()->after('tipo_relacionamento');
            }
            if (!Schema::hasColumn('users', 'busca_idade_min')) {
                $table->unsignedTinyInteger('busca_idade_min')->nullable()->after('busca_genero');
            }
            if (!Schema::hasColumn('users', 'busca_idade_max')) {
                $table->unsignedTinyInteger('busca_idade_max')->nullable()->after('busca_idade_min');
            }
            if (!Schema::hasColumn('users', 'busca_distancia')) {
                $table->unsignedSmallInteger('busca_distancia')->nullable()->after('busca_idade_max');
            }

            // Dados pessoais adicionais
            if (!Schema::hasColumn('users', 'filhos')) {
                $table->unsignedTinyInteger('filhos')->nullable()->after('busca_distancia');
            }
            if (!Schema::hasColumn('users', 'escolaridade')) {
                $table->string('escolaridade', 100)->nullable()->after('filhos');
            }
            if (!Schema::hasColumn('users', 'profissao')) {
                $table->string('profissao', 150)->nullable()->after('escolaridade');
            }
            if (!Schema::hasColumn('users', 'religiao')) {
                $table->string('religiao', 100)->nullable()->after('profissao');
            }
            if (!Schema::hasColumn('users', 'humor')) {
                $table->string('humor', 100)->nullable()->after('religiao');
            }

            // Localização normalizada
            if (!Schema::hasColumn('users', 'pais_id')) {
                $table->foreignId('pais_id')->nullable()->after('humor')->constrained('pais');
            }
            if (!Schema::hasColumn('users', 'provincia_id')) {
                $table->foreignId('provincia_id')->nullable()->after('pais_id')->constrained('provincia');
            }
            if (!Schema::hasColumn('users', 'cidade_id')) {
                $table->foreignId('cidade_id')->nullable()->after('provincia_id')->constrained('cidade');
            }
            if (!Schema::hasColumn('users', 'mora_com')) {
                $table->string('mora_com', 100)->nullable()->after('cidade_id');
            }

            // Aparência física
            if (!Schema::hasColumn('users', 'cor_pele')) {
                $table->string('cor_pele', 50)->nullable()->after('mora_com');
            }
            if (!Schema::hasColumn('users', 'cor_olhos')) {
                $table->string('cor_olhos', 50)->nullable()->after('cor_pele');
            }
            if (!Schema::hasColumn('users', 'cor_cabelos')) {
                $table->string('cor_cabelos', 50)->nullable()->after('cor_olhos');
            }
            if (!Schema::hasColumn('users', 'altura')) {
                $table->float('altura')->nullable()->after('cor_cabelos');
            }
            if (!Schema::hasColumn('users', 'peso')) {
                $table->float('peso')->nullable()->after('altura');
            }

            // Hábitos e estilo de vida
            if (!Schema::hasColumn('users', 'pratica_esporte')) {
                $table->boolean('pratica_esporte')->nullable()->after('peso');
            }
            if (!Schema::hasColumn('users', 'fuma')) {
                $table->boolean('fuma')->nullable()->after('pratica_esporte');
            }
            if (!Schema::hasColumn('users', 'bebe')) {
                $table->boolean('bebe')->nullable()->after('fuma');
            }
            if (!Schema::hasColumn('users', 'como_me_considero_fisicamente')) {
                $table->text('como_me_considero_fisicamente')->nullable()->after('bebe');
            }

            // Coordenadas de GPS
            if (!Schema::hasColumn('users', 'latitude')) {
                $table->decimal('latitude', 10, 7)->nullable()->after('como_me_considero_fisicamente');
            }
            if (!Schema::hasColumn('users', 'longitude')) {
                $table->decimal('longitude', 10, 7)->nullable()->after('latitude');
            }

            // Plano e limites extras
            if (!Schema::hasColumn('users', 'plano_expira_em')) {
                $table->timestamp('plano_expira_em')->nullable()->after('plano_id');
            }
            if (!Schema::hasColumn('users', 'limite_solicitacoes')) {
                $table->integer('limite_solicitacoes')->nullable()->after('plano_expira_em');
            }
        });
    }

    public function down(): void
    {
        // Remover FKs primeiro
        Schema::table('users', function (Blueprint $table) {
            if (Schema::hasColumn('users', 'pais_id')) {
                $table->dropForeign(['pais_id']);
            }
            if (Schema::hasColumn('users', 'provincia_id')) {
                $table->dropForeign(['provincia_id']);
            }
            if (Schema::hasColumn('users', 'cidade_id')) {
                $table->dropForeign(['cidade_id']);
            }
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'apelido',
                'sexualidade',
                'estado_civil',
                'signo',
                'is_verified',
                'is_banned',
                'motivo_banamento',
                'ultimo_login',
                'role',
                'tipo_relacionamento',
                'busca_genero',
                'busca_idade_min',
                'busca_idade_max',
                'busca_distancia',
                'filhos',
                'escolaridade',
                'profissao',
                'religiao',
                'humor',
                'pais_id',
                'provincia_id',
                'cidade_id',
                'mora_com',
                'cor_pele',
                'cor_olhos',
                'cor_cabelos',
                'altura',
                'peso',
                'pratica_esporte',
                'fuma',
                'bebe',
                'como_me_considero_fisicamente',
                'latitude',
                'longitude',
                'plano_expira_em',
                'limite_solicitacoes',
            ]);
        });
    }
};
