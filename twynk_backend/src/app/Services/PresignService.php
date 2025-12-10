<?php

namespace App\Services;

use Aws\S3\S3Client;

class PresignService
{
    /**
     * Instância do cliente S3 compatível com B2.
     *
     * @var S3Client
     */
    public S3Client $s3;

    /**
     * Nome do bucket B2.
     *
     * @var string
     */
    protected string $bucket;

    public function __construct()
    {
        $this->s3 = new S3Client([
            'version' => 'latest',
            'region' => env('B2_S3_REGION'),
            'endpoint' => env('B2_S3_ENDPOINT'),
            'use_path_style_endpoint' => false,
            'credentials' => [
                'key' => env('B2_S3_KEY_ID'),
                'secret' => env('B2_S3_APPLICATION_KEY'),
            ],
        ]);

        $this->bucket = (string) env('B2_BUCKET');
    }

    /**
     * Gera URL presignada para upload (PUT).
     */
    public function getPresignedPutUrl(string $key, string $contentType = 'application/octet-stream', int $expires = 300): string
    {
        $cmd = $this->s3->getCommand('PutObject', [
            'Bucket' => $this->bucket,
            'Key' => $key,
            'ACL' => 'private',
            'ContentType' => $contentType,
        ]);

        $request = $this->s3->createPresignedRequest($cmd, "+{$expires} seconds");

        return (string) $request->getUri();
    }

    /**
     * Gera URL presignada para download (GET).
     */
    public function getPresignedGetUrl(string $key, int $expires = 3600): string
    {
        $cmd = $this->s3->getCommand('GetObject', [
            'Bucket' => $this->bucket,
            'Key' => $key,
        ]);

        $request = $this->s3->createPresignedRequest($cmd, "+{$expires} seconds");

        return (string) $request->getUri();
    }
}
