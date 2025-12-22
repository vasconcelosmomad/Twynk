<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('provincia', function (Blueprint $table) {
            if (Schema::hasColumn('provincia', 'status')) {
                $table->dropColumn('status');
            }
        });

        Schema::table('cidade', function (Blueprint $table) {
            if (Schema::hasColumn('cidade', 'status')) {
                $table->dropColumn('status');
            }
        });
    }

    public function down(): void
    {
        Schema::table('provincia', function (Blueprint $table) {
            if (!Schema::hasColumn('provincia', 'status')) {
                $table->enum('status', ['ativo', 'inativo'])->default('ativo');
            }
        });

        Schema::table('cidade', function (Blueprint $table) {
            if (!Schema::hasColumn('cidade', 'status')) {
                $table->enum('status', ['ativo', 'inativo'])->default('ativo');
            }
        });
    }
};
