<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Like extends Model
{
    use HasFactory;

    protected $table = 'likes';

    protected $fillable = [
        'id_usuario_origem',
        'id_usuario_destino',
        'data_like',
    ];

    protected $casts = [
        'data_like' => 'datetime',
    ];

    /**
     * Relacionamento com usuário origem
     */
    public function usuarioOrigem(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario_origem');
    }

    /**
     * Relacionamento com usuário destino
     */
    public function usuarioDestino(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_usuario_destino');
    }
}

