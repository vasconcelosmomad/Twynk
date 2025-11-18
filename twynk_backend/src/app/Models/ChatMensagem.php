<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ChatMensagem extends Model
{
    use HasFactory;

    protected $table = 'chat_mensagem';

    protected $fillable = [
        'chat_id',
        'remetente_id',
        'destinatario_id',
        'tipo',
        'conteudo',
        'data_envio',
    ];

    protected $casts = [
        'data_envio' => 'datetime',
    ];

    /**
     * Relacionamento com remetente
     */
    public function remetente(): BelongsTo
    {
        return $this->belongsTo(User::class, 'remetente_id');
    }

    /**
     * Relacionamento com destinatário
     */
    public function destinatario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'destinatario_id');
    }
}

