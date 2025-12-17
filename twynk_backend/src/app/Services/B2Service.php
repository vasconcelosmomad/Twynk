<?php

namespace App\Services;

use Illuminate\Support\Facades\Storage;

class B2Service
{
    protected string $disk = 'b2';

    /**
     * Upload de arquivo para B2
     */
    public function uploadFile(string $localPath, string $key, string $mimeType): void
    {
        Storage::disk($this->disk)->putFileAs(
            dirname($key),
            $localPath,
            basename($key),
            ['ContentType' => $mimeType]
        );
    }

    /**
     * Gerar URL temporária (presigned GET)
     */
    public function getPresignedGetUrl(string $key, int $seconds = 3600): string
    {
        return Storage::disk($this->disk)
            ->temporaryUrl($key, now()->addSeconds($seconds));
    }

    /**
     * Deletar arquivo do bucket
     */
    public function delete(string $key): void
    {
        Storage::disk($this->disk)->delete($key);
    }
}
