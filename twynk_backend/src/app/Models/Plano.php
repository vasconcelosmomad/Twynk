<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Plano extends Model
{
    use HasFactory;

    protected $table = 'planos';

    protected $fillable = [
        'nome',
        'descricao',
        'duracao',
        'preco',
        'ativo',
    ];

    protected $casts = [
        'preco' => 'decimal:2',
        'ativo' => 'boolean',
    ];

    /**
     * Relacionamento com benefícios do plano
     */
    public function beneficios(): HasOne
    {
        return $this->hasOne(BeneficiosPlano::class, 'plano_id');
    }

    /**
     * Relacionamento com usuários
     */
    public function usuarios(): HasMany
    {
        return $this->hasMany(User::class, 'plano_id');
    }

    /**
     * Relacionamento com assinaturas
     */
    public function assinaturas(): HasMany
    {
        return $this->hasMany(Assinatura::class, 'plano_id');
    }

    /**
     * Relacionamento com transações
     */
    public function transacoes(): HasMany
    {
        return $this->hasMany(Transacao::class, 'plano_id');
    }
}

