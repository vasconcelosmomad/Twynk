<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;
use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable;

    protected $table = 'users';

    // Mapear os nomes dos campos de timestamp
    const CREATED_AT = 'created_at';
    const UPDATED_AT = 'updated_at';

    protected $fillable = [
        // Dados básicos
        'nome',
        'apelido',
        'genero',
        'sexualidade',
        'interesse',
        'estado_civil',
        'data_nascimento',
        'signo',
        'email',
        'password',
        'google_id',
        'is_verified',
        'is_banned',
        'motivo_banamento',
        'ultimo_login',
        'role',
        
        // Preferências de relacionamento / busca
        'tipo_relacionamento',
        'busca_genero',
        'busca_idade_min',
        'busca_idade_max',
        'busca_distancia',
        
        // Dados pessoais adicionais
        'filhos',
        'escolaridade',
        'profissao',
        'religiao',
        'humor',
        
        // Localização normalizada (chaves estrangeiras)
        'pais_id',
        'provincia_id',
        'cidade_id',
        'mora_com',
        
        // Aparência física
        'cor_pele',
        'cor_olhos',
        'cor_cabelos',
        'altura',
        'peso',
        
        // Hábitos e estilo de vida
        'pratica_esporte',
        'fuma',
        'bebe',
        'como_me_considero_fisicamente',
        
        // Coordenadas de GPS
        'latitude',
        'longitude',
        
        'status',
        
        // Plano e limites
        'plano_id',
        'plano_expira_em',
        'limite_solicitacoes',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'data_nascimento' => 'date',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
        'ultimo_login' => 'datetime',
        'plano_expira_em' => 'datetime',
        'password' => 'hashed',
        'is_verified' => 'boolean',
        'is_banned' => 'boolean',
        'latitude' => 'decimal:7',
        'longitude' => 'decimal:7',
        'altura' => 'float',
        'peso' => 'float',
        'filhos' => 'integer',
        'busca_idade_min' => 'integer',
        'busca_idade_max' => 'integer',
        'busca_distancia' => 'integer',
        'limite_solicitacoes' => 'integer',
    ];

    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }

    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims()
    {
        // Carregar relacionamentos necessários se ainda não estiverem carregados
        if (!$this->relationLoaded('plano')) {
            $this->load('plano');
        }
        if (!$this->relationLoaded('assinaturas')) {
            $this->load('assinaturas');
        }
        if (!$this->relationLoaded('creditos')) {
            $this->load('creditos');
        }

        // Buscar assinatura ativa
        $assinaturaAtiva = $this->assinaturas->where('ativo', true)->first();

        return [
            'name' => $this->nome,
            'email' => $this->email,
            'plan' => $this->plano ? $this->plano->id : null,
            'plan_exp' => $assinaturaAtiva && $assinaturaAtiva->data_fim 
                ? $assinaturaAtiva->data_fim->timestamp 
                : null,
            'role' => $this->role ?? 'user',
            'is_verified' => $this->is_verified ?? false,
            'credits' => $this->creditos ? (float) $this->creditos->saldo : 0.0,
        ];
    }

    /**
     * Relacionamento com país
     */
    public function pais(): BelongsTo
    {
        return $this->belongsTo(Pais::class, 'pais_id');
    }

    /**
     * Relacionamento com província
     */
    public function provincia(): BelongsTo
    {
        return $this->belongsTo(Provincia::class, 'provincia_id');
    }

    /**
     * Relacionamento com cidade
     */
    public function cidade(): BelongsTo
    {
        return $this->belongsTo(Cidade::class, 'cidade_id');
    }

    /**
     * Relacionamento com plano
     */
    public function plano(): BelongsTo
    {
        return $this->belongsTo(Plano::class, 'plano_id');
    }

    /**
     * Relacionamento com assinaturas
     */
    public function assinaturas(): HasMany
    {
        return $this->hasMany(Assinatura::class, 'usuario_id');
    }

    /**
     * Relacionamento com créditos
     */
    public function creditos(): HasOne
    {
        return $this->hasOne(Credito::class, 'usuario_id');
    }

    /**
     * Relacionamento com transações
     */
    public function transacoes(): HasMany
    {
        return $this->hasMany(Transacao::class, 'usuario_id');
    }

    /**
     * Likes enviados
     */
    public function likesEnviados(): HasMany
    {
        return $this->hasMany(Like::class, 'id_usuario_origem');
    }

    /**
     * Likes recebidos
     */
    public function likesRecebidos(): HasMany
    {
        return $this->hasMany(Like::class, 'id_usuario_destino');
    }

    /**
     * Mensagens enviadas
     */
    public function mensagensEnviadas(): HasMany
    {
        return $this->hasMany(Mensagem::class, 'remetente_id');
    }

    /**
     * Mensagens recebidas
     */
    public function mensagensRecebidas(): HasMany
    {
        return $this->hasMany(Mensagem::class, 'destinatario_id');
    }

    /**
     * Chat mensagens enviadas
     */
    public function chatMensagensEnviadas(): HasMany
    {
        return $this->hasMany(ChatMensagem::class, 'remetente_id');
    }

    /**
     * Chat mensagens recebidas
     */
    public function chatMensagensRecebidas(): HasMany
    {
        return $this->hasMany(ChatMensagem::class, 'destinatario_id');
    }

    /**
     * Solicitações de chat enviadas
     */
    public function solicitacoesEnviadas(): HasMany
    {
        return $this->hasMany(SolicitacaoChat::class, 'solicitante_id');
    }

    /**
     * Solicitações de chat recebidas
     */
    public function solicitacoesRecebidas(): HasMany
    {
        return $this->hasMany(SolicitacaoChat::class, 'solicitado_id');
    }

    /**
     * Mídias do usuário
     */
    public function medias(): HasMany
    {
        return $this->hasMany(Media::class, 'user_uid', 'uid');
    }

    /**
     * Status/publicações do usuário
     */
    public function statusPublicacoes(): HasMany
    {
        return $this->hasMany(StatusPublicacao::class, 'usuario_id');
    }

    /**
     * Visualizações feitas pelo usuário
     */
    public function visualizacoesFeitas(): HasMany
    {
        return $this->hasMany(Visualizacao::class, 'id_visualizador');
    }

    /**
     * Visualizações recebidas pelo usuário
     */
    public function visualizacoesRecebidas(): HasMany
    {
        return $this->hasMany(Visualizacao::class, 'id_visualizado');
    }
}
