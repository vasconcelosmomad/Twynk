<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Mensagem extends Model
{
    use HasFactory;

    protected $table = 'mensagens';

    protected $fillable = [
        'remetente_id',
        'destinatario_id',
        'conteudo',
        'lida',
        'data_envio',
    ];

    protected $casts = [
        'lida' => 'boolean',
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

