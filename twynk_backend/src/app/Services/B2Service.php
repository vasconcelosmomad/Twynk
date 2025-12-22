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
        $stream = fopen($localPath, 'r');

        Storage::disk($this->disk)->put(
            $key,
            $stream,
            ['ContentType' => $mimeType]
        );

        if (is_resource($stream)) {
            fclose($stream);
        }
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

    /**
     * Deletar todos os arquivos sob um determinado prefixo/pasta.
     */
    public function deleteFolder(string $prefix): void
    {
        $disk = Storage::disk($this->disk);
        $files = $disk->allFiles($prefix);

        if (!empty($files)) {
            $disk->delete($files);
        }
    }
}
