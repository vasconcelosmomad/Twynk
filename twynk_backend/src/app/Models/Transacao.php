<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Transacao extends Model
{
    use HasFactory;

    protected $table = 'transacoes';

    protected $fillable = [
        'usuario_id',
        'plano_id',
        'valor_pago',
        'metodo_pagamento',
        'data_pagamento',
        'status',
    ];

    protected $casts = [
        'valor_pago' => 'decimal:2',
        'data_pagamento' => 'datetime',
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

