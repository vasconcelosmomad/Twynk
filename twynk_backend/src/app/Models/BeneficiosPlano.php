<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BeneficiosPlano extends Model
{
    use HasFactory;

    protected $table = 'beneficios_plano';

    protected $fillable = [
        'plano_id',
        'curtidas_dia',
        'mensagens_dia',
        'video_tempo_min',
        'boost_semana',
        'pode_chat',
        'pode_video',
        'ver_quem_curtiu',
        'enviar_fotos',
        'creditos_iniciais',
        'suporte_prioritario',
    ];

    protected $casts = [
        'curtidas_dia' => 'integer',
        'mensagens_dia' => 'integer',
        'video_tempo_min' => 'integer',
        'boost_semana' => 'integer',
        'pode_chat' => 'boolean',
        'pode_video' => 'boolean',
        'ver_quem_curtiu' => 'boolean',
        'enviar_fotos' => 'boolean',
        'creditos_iniciais' => 'decimal:2',
        'suporte_prioritario' => 'boolean',
    ];

    /**
     * Relacionamento com plano
     */
    public function plano(): BelongsTo
    {
        return $this->belongsTo(Plano::class, 'plano_id');
    }
}

