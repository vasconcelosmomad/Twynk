<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StatusPublicacao extends Model
{
    use HasFactory;

    protected $table = 'status_publicacoes';

    protected $fillable = [
        'usuario_id',
        'texto',
        'imagem_url',
        'data_publicacao',
    ];

    protected $casts = [
        'data_publicacao' => 'datetime',
    ];

    /**
     * Relacionamento com usuário
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }
}

