<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SolicitacaoChat extends Model
{
    use HasFactory;

    protected $table = 'solicitacoes_chat';

    protected $fillable = [
        'solicitante_id',
        'solicitado_id',
        'tipo',
        'status',
        'data_solicitacao',
    ];

    protected $casts = [
        'data_solicitacao' => 'datetime',
    ];

    /**
     * Relacionamento com solicitante
     */
    public function solicitante(): BelongsTo
    {
        return $this->belongsTo(User::class, 'solicitante_id');
    }

    /**
     * Relacionamento com solicitado
     */
    public function solicitado(): BelongsTo
    {
        return $this->belongsTo(User::class, 'solicitado_id');
    }
}

