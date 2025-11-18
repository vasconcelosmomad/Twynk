<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Visualizacao extends Model
{
    use HasFactory;

    protected $table = 'visualizacoes';

    protected $fillable = [
        'id_visualizador',
        'id_visualizado',
        'data_visualizacao',
    ];

    protected $casts = [
        'data_visualizacao' => 'datetime',
    ];

    /**
     * Relacionamento com visualizador
     */
    public function visualizador(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_visualizador');
    }

    /**
     * Relacionamento com visualizado
     */
    public function visualizado(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_visualizado');
    }
}

