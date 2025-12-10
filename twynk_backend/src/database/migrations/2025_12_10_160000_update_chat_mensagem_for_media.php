<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('chat_mensagem', function (Blueprint $table) {
            // Campo opcional para associar uma mídia (tabela media)
            $table->unsignedBigInteger('media_id')->nullable()->after('conteudo');

            // Índice para consultas por chat
            $table->index('chat_id');
        });

        // Ajustar enum "tipo" para apenas 'texto' e 'media'
        DB::statement("ALTER TABLE chat_mensagem MODIFY COLUMN tipo ENUM('texto','media') NOT NULL DEFAULT 'texto'");

        Schema::table('chat_mensagem', function (Blueprint $table) {
            // Chave estrangeira para media(id) com ON DELETE SET NULL
            $table->foreign('media_id')
                ->references('id')
                ->on('media')
                ->nullOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('chat_mensagem', function (Blueprint $table) {
            // Remover foreign key e coluna media_id
            $table->dropForeign(['media_id']);
            $table->dropColumn('media_id');

            // Remover índice de chat_id
            $table->dropIndex('chat_mensagem_chat_id_index');
        });

        // Restaurar enum original de tipo
        DB::statement("ALTER TABLE chat_mensagem MODIFY COLUMN tipo ENUM('texto','imagem','audio','video') NOT NULL DEFAULT 'texto'");
    }
};
