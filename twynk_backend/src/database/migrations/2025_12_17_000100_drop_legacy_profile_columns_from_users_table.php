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
        if (Schema::hasColumn('users', 'foto_galeria')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('foto_galeria');
            });
        }

        if (Schema::hasColumn('users', 'foto_perfil')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('foto_perfil');
            });
        }

        if (Schema::hasColumn('users', 'bio')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('bio');
            });
        }

        if (Schema::hasColumn('users', 'localizacao')) {
            Schema::table('users', function (Blueprint $table) {
                $table->dropColumn('localizacao');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('foto_perfil', 255)->nullable();
            $table->text('bio')->nullable();
            $table->string('localizacao', 255)->nullable();
            $table->json('foto_galeria')->nullable();
        });
    }
};
