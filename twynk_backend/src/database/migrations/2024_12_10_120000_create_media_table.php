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
        Schema::create('media', function (Blueprint $table) {
            $table->id();
            $table->string('user_uid', 255);           // UID do Firebase
            $table->enum('type', ['image', 'video', 'profile', 'chat']); // tipo de mídia
            $table->string('filename', 255)->nullable(); // nome do arquivo original
            $table->string('path', 500);               // caminho no storage
            $table->string('url', 500)->nullable();    // URL pública ou presigned
            $table->bigInteger('size')->nullable();     // tamanho do arquivo em bytes
            $table->timestamp('created_at')->useCurrent();
            $table->timestamp('updated_at')->useCurrent()->useCurrentOnUpdate();

            // Índices para performance
            $table->index('user_uid', 'idx_user_uid');
            $table->index('type', 'idx_type');
            $table->index(['user_uid', 'type'], 'idx_user_type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('media');
    }
};
