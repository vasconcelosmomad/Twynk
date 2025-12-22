<?php

namespace App\Http\Controllers;

use App\Models\Media;
use App\Services\B2Service;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class MediaController extends Controller
{
    protected B2Service $b2;

    public function __construct(B2Service $b2)
    {
        $this->b2 = $b2;
    }

    /**
     * Upload de arquivo via backend (JWT)
     */
    public function upload(Request $request)
    {
        $maxSize = match ($request->type) {
            'profile' => 2048,    // 2MB
            'image'   => 5120,    // 5MB
            'chat'    => 10240,   // 10MB
            'video'   => 102400,  // 100MB
            default   => 0,
        };

        try {
            $request->validate([
                'type' => 'required|in:image,video,profile,chat',
                'file' => "required|file|max:$maxSize",
            ]);
        } catch (ValidationException $e) {
            $uploadedFile = $request->file('file');

            Log::warning('Falha de validacao no upload de media', [
                'errors' => $e->errors(),
                'file_present' => $uploadedFile !== null,
                'file_error_code' => $uploadedFile?->getError(),
                'file_error_message' => method_exists($uploadedFile, 'getErrorMessage') ? $uploadedFile?->getErrorMessage() : null,
                'file_size' => $uploadedFile?->getSize(),
                'file_mime' => $uploadedFile?->getMimeType(),
            ]);

            throw $e;
        }

        $mimeRules = [
            'image'   => ['image/jpeg', 'image/png', 'image/webp'],
            'profile' => ['image/jpeg', 'image/png', 'image/webp'],
            'video'   => ['video/mp4', 'video/webm'],
            'chat'    => ['image/jpeg', 'image/png', 'video/mp4'],
        ];

        $file = $request->file('file');

        $user = $request->user();
        $uid = $user->uid ?? (string) $user->getKey();

        // Tentar obter MIME real do arquivo; se falhar (tmp file ausente ou ilegível),
        // fazer fallback para o MIME enviado pelo cliente.
        try {
            $resolvedMime = $file->getMimeType();
        } catch (\Throwable $e) {
            $resolvedMime = $file->getClientMimeType();

            Log::warning('Falha ao obter MIME type via Fileinfo, usando clientMimeType como fallback', [
                'user_uid' => $uid ?? null,
                'path' => $file->getPathname(),
                'client_mime' => $file->getClientMimeType(),
                'error' => $e->getMessage(),
            ]);
        }

        if (!in_array($resolvedMime, $mimeRules[$request->type])) {
            return response()->json(['message' => 'Tipo de ficheiro não permitido'], 422);
        }

        $folder = match ($request->type) {
            'profile' => "users/{$uid}/profile/",
            'image'   => "users/{$uid}/images/",
            'video'   => "users/{$uid}/videos/",
            'chat'    => "users/{$uid}/chats/",
        };

        // Se for foto de perfil, garantir que haja apenas uma mídia de perfil por usuário,
        // removendo registros anteriores (e respectivos ficheiros no B2 via evento deleting)
        // e limpando possíveis arquivos órfãos na pasta do B2.
        if ($request->type === 'profile') {
            $this->b2->deleteFolder("users/{$uid}/profile");

            Media::where('user_uid', $uid)
                ->where('type', 'profile')
                ->get()
                ->each->delete();
        }

        $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();
        $path = $folder . $filename;

        try {
            $this->b2->uploadFile($file->getPathname(), $path, $resolvedMime);
        } catch (\Throwable $e) {
            Log::error('Erro ao enviar ficheiro para B2', [
                'user_uid' => $uid ?? null,
                'path' => $path ?? null,
                'exception' => $e,
            ]);

            return response()->json(['message' => 'Erro ao enviar ficheiro'], 500);
        }

        $media = Media::create([
            'user_uid' => $uid,
            'type' => $request->type,
            'filename' => $file->getClientOriginalName(),
            'path' => $path,
            'size' => $file->getSize(),
        ]);

        return response()->json([
            'media' => $media,
            'url' => $this->b2->getPresignedGetUrl($path, 3600),
        ], 201);
    }

    public function index(Request $request)
    {
        $user = $request->user();
        $uid = $user->uid ?? (string) $user->getKey();

        $items = Media::where('user_uid', $uid)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($items);
    }

    public function destroy(Request $request, $id)
    {
        $user = $request->user();
        $uid = $user->uid ?? (string) $user->getKey();

        $media = Media::where('id', $id)
            ->where('user_uid', $uid)
            ->firstOrFail();

        $media->delete();

        return response()->json(null, 204);
    }

    public function generateViewUrl(Request $request)
    {
        $request->validate([
            'path' => 'required|string',
        ]);

        $uid = $request->user()->uid;

        if (!str_starts_with($request->path, "users/{$uid}/")) {
            return response()->json(['message' => 'Acesso negado'], 403);
        }

        return response()->json([
            'url' => $this->b2->getPresignedGetUrl($request->path, 3600),
        ]);
    }
}
