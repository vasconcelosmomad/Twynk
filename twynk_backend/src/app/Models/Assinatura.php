<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Assinatura extends Model
{
    use HasFactory;

    protected $table = 'assinaturas';

    protected $fillable = [
        'usuario_id',
        'plano_id',
        'data_inicio',
        'data_fim',
        'ativo',
    ];

    protected $casts = [
        'data_inicio' => 'datetime',
        'data_fim' => 'datetime',
        'ativo' => 'boolean',
    ];

    /**
     * Relacionamento com usuário
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }

    /**
     * Relacionamento com plano
     */
    public function plano(): BelongsTo
    {
        return $this->belongsTo(Plano::class, 'plano_id');
    }
}

