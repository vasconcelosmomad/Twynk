<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Credito extends Model
{
    use HasFactory;

    protected $table = 'creditos';

    protected $fillable = [
        'usuario_id',
        'saldo',
        'ultimo_update',
    ];

    protected $casts = [
        'saldo' => 'decimal:2',
        'ultimo_update' => 'datetime',
    ];

    /**
     * Relacionamento com usuário
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }
}

