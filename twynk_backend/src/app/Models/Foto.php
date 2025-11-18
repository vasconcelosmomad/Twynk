<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Foto extends Model
{
    use HasFactory;

    protected $table = 'fotos';

    protected $fillable = [
        'usuario_id',
        'url_foto',
        'descricao',
        'data_upload',
    ];

    protected $casts = [
        'data_upload' => 'datetime',
    ];

    /**
     * Relacionamento com usuário
     */
    public function usuario(): BelongsTo
    {
        return $this->belongsTo(User::class, 'usuario_id');
    }
}

