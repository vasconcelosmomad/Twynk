<?php

namespace App\Models;

use App\Services\GCSService;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Media extends Model
{
    use HasFactory;

    protected $table = 'media';

    protected $fillable = [
        'user_uid',
        'type',
        'filename',
        'path',   // key no GCS
        'size',
    ];

    protected $casts = [
        'size' => 'integer',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /* ==============================
     | RELACIONAMENTOS
     ============================== */

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_uid', 'uid');
    }

    /* ==============================
     | HELPERS DE TIPO
     ============================== */

    public function isImage(): bool
    {
        return in_array($this->type, ['image', 'profile']);
    }

    public function isVideo(): bool
    {
        return $this->type === 'video';
    }

    public function isChat(): bool
    {
        return $this->type === 'chat';
    }

    /* ==============================
     | URL TEMPORÁRIA (VIEW)
     ============================== */

    public function getViewUrl(int $expires = 3600): string
    {
        return app(GCSService::class)
            ->generateViewUrl($this->path, $expires);
    }

    /* ==============================
     | FORMATADORES
     ============================== */

    public function getFormattedSizeAttribute(): string
    {
        if (!$this->size) {
            return '0 B';
        }

        $units = ['B', 'KB', 'MB', 'GB'];
        $bytes = $this->size;

        for ($i = 0; $bytes >= 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }

        return round($bytes, 2) . ' ' . $units[$i];
    }

    /* ==============================
     | SCOPES
     ============================== */

    public function scopeByType($query, string $type)
    {
        return $query->where('type', $type);
    }

    public function scopeByUser($query, string $userUid)
    {
        return $query->where('user_uid', $userUid);
    }

    public function scopeRecent($query, int $days = 30)
    {
        return $query->where('created_at', '>=', now()->subDays($days));
    }

    /* ==============================
     | EVENTS
     ============================== */

    protected static function booted()
    {
        static::deleting(function (Media $media) {
            if ($media->path) {
                app(GCSService::class)->delete($media->path);
            }
        });
    }
}
