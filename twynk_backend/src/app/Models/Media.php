<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

class Media extends Model
{
    use HasFactory;

    protected $table = 'media';

    protected $fillable = [
        'user_uid',
        'type',
        'filename',
        'path',
        'url',
        'size',
    ];

    protected $casts = [
        'size' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Retorna URL pública ou temporária baseada no tipo
     * usando o disco B2 compatível com S3.
     */
    public function getUrlAttribute($value)
    {
        // Perfil sempre público
        if ($this->type === 'profile') {
            return Storage::disk('b2')->url($this->path);
        }

        // Mídias de chat com URL temporária de 24h
        if ($this->type === 'chat') {
            return Storage::disk('b2')->temporaryUrl($this->path, now()->addHours(24));
        }

        // image / video - 1 hora de acesso
        return Storage::disk('b2')->temporaryUrl($this->path, now()->addHour());
    }

    /**
     * Gera URL presigned para upload
     */
    public function generatePresignedUploadUrl(string $filename, int $contentLength = null): string
    {
        return Storage::disk('s3')->putFileAs(
            "media/{$this->user_uid}",
            $filename,
            $filename,
            ['ContentLength' => $contentLength]
        );
    }

    /**
     * Verifica se é uma imagem
     */
    public function isImage(): bool
    {
        return $this->type === 'image';
    }

    /**
     * Verifica se é um vídeo
     */
    public function isVideo(): bool
    {
        return $this->type === 'video';
    }

    /**
     * Verifica se é foto de perfil
     */
    public function isProfile(): bool
    {
        return $this->type === 'profile';
    }

    /**
     * Verifica se é mídia de chat
     */
    public function isChat(): bool
    {
        return $this->type === 'chat';
    }

    /**
     * Formata tamanho do arquivo para exibição
     */
    public function getFormattedSizeAttribute(): string
    {
        if (!$this->size) {
            return 'Unknown';
        }

        $bytes = $this->size;
        $units = ['B', 'KB', 'MB', 'GB'];

        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }

        return round($bytes, 2) . ' ' . $units[$i];
    }

    /**
     * Relacionamento com usuário via UID
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_uid', 'uid');
    }

    /**
     * Scope para filtrar por tipo
     */
    public function scopeByType($query, string $type)
    {
        return $query->where('type', $type);
    }

    /**
     * Scope para filtrar por usuário
     */
    public function scopeByUser($query, string $userUid)
    {
        return $query->where('user_uid', $userUid);
    }

    /**
     * Scope para mídias recentes
     */
    public function scopeRecent($query, int $days = 30)
    {
        return $query->where('created_at', '>=', now()->subDays($days));
    }

    /**
     * Deleta o arquivo do storage antes de deletar o registro
     */
    public function deleteStorage(): bool
    {
        if ($this->path) {
            Storage::disk('b2')->delete($this->path);
        }

        return true;
    }

    /**
     * Boot do modelo para eventos
     */
    protected static function boot()
    {
        parent::boot();

        static::deleting(function ($media) {
            $media->deleteStorage();
        });
    }
}
