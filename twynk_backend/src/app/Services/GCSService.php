<?php

namespace App\Services;

use Google\Cloud\Storage\StorageClient;
use Illuminate\Support\Str;

class GCSService
{
    public StorageClient $storage;
    public string $bucket;

    public function __construct()
    {
        $this->storage = new StorageClient([
            'keyFilePath' => storage_path('app/' . config('services.gcs.key_file', 'gcs-service-account.json')),
        ]);

        $this->bucket = config('services.gcs.bucket');
    }

    public function getPresignedPutUrl(string $key, string $contentType = 'application/octet-stream', int $expires = 300): string
    {
        $bucket = $this->storage->bucket($this->bucket);
        $object = $bucket->object($key);

        return $object->signedUrl(
            now()->addSeconds($expires),
            [
                'version' => 'v4',
                'method' => 'PUT',
                'contentType' => $contentType,
            ]
        );
    }

    /**
     * Gera uma URL segura para UPLOAD (PUT)
     */
    public function generateUploadUrl(
        string $userUid,
        string $type,
        string $extension,
        int $expires = 300
    ): array {
        $key = $this->buildObjectKey($userUid, $type, $extension);

        $bucket = $this->storage->bucket($this->bucket);
        $object = $bucket->object($key);

        $url = $object->signedUrl(
            now()->addSeconds($expires),
            [
                'version' => 'v4',
                'method'  => 'PUT',
            ]
        );

        return [
            'key' => $key,
            'url' => $url,
            'expires_in' => $expires,
        ];
    }

    /**
     * Gera URL temporária para VISUALIZAÇÃO (GET)
     */
    public function generateViewUrl(string $key, int $expires = 3600): string
    {
        $bucket = $this->storage->bucket($this->bucket);
        $object = $bucket->object($key);

        return $object->signedUrl(
            now()->addSeconds($expires),
            [
                'version' => 'v4',
            ]
        );
    }

    public function getPresignedGetUrl(string $key, int $expires = 3600): string
    {
        return $this->generateViewUrl($key, $expires);
    }

    public function uploadFile(string $localPath, string $remotePath, string $contentType): void
    {
        $bucket = $this->storage->bucket($this->bucket);

        $bucket->upload(
            fopen($localPath, 'r'),
            [
                'name' => $remotePath,
                'metadata' => [
                    'contentType' => $contentType,
                ],
            ]
        );
    }

    /**
     * Remove ficheiro do GCS
     */
    public function delete(string $key): void
    {
        $bucket = $this->storage->bucket($this->bucket);
        $object = $bucket->object($key);

        if ($object->exists()) {
            $object->delete();
        }
    }

    /**
     * Padrão de caminho seguro
     */
    protected function buildObjectKey(string $userUid, string $type, string $extension): string
    {
        return sprintf(
            'users/%s/%s/%s.%s',
            $userUid,
            $type,
            Str::uuid(),
            ltrim($extension, '.')
        );
    }
}
