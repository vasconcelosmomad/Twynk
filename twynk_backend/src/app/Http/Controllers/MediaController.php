<?php

namespace App\Http\Controllers;

use App\Models\Media;
use App\Services\GCSService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class MediaController extends Controller
{
    /**
     * Serviço responsável por gerar URLs presignadas.
     */
    protected GCSService $gcs;

    public function __construct(GCSService $gcs)
    {
        $this->gcs = $gcs;
    }

    /**
     * Upload direto via backend (híbrido seguro).
     */
    public function upload(Request $request)
    {
        $request->validate([
            'file' => 'required|file|max:10240',
            'type' => 'required|in:image,video,profile,chat',
        ]);

        $mimeRules = [
            'image' => ['image/jpeg', 'image/png', 'image/webp'],
            'profile' => ['image/jpeg', 'image/png', 'image/webp'],
            'video' => ['video/mp4', 'video/webm'],
            'chat' => ['image/jpeg', 'image/png', 'video/mp4'],
        ];

        $file = $request->file('file');
        $mimeType = $file->getMimeType();
        if (!in_array($mimeType, $mimeRules[$request->type])) {
            return response()->json(['message' => 'Tipo de ficheiro não permitido'], 422);
        }

        $user = $request->user();
        $uid = $user->uid;

        $ext = $file->getClientOriginalExtension();
        $folder = match ($request->type) {
            'profile' => "users/{$uid}/profile/",
            'image'   => "users/{$uid}/images/",
            'video'   => "users/{$uid}/videos/",
            'chat'    => "users/{$uid}/chats/",
        };

        $filename = now()->timestamp . '-' . Str::uuid() . '.' . $ext;
        $key = $folder . $filename;

        $this->gcs->uploadFile($file->getPathname(), $key, $mimeType);

        $media = Media::create([
            'user_uid' => $uid,
            'type' => $request->type,
            'filename' => $file->getClientOriginalName(),
            'path' => $key,
            'size' => $file->getSize(),
        ]);

        $url = $this->gcs->getPresignedGetUrl($key, 3600);

        return response()->json([
            'media' => $media,
            'url' => $url,
        ], 201);
    }

    /**
     * 3) Listar mídias do usuário autenticado (JWT).
     */
    public function index(Request $request)
    {
        $user = $request->user();

        $items = Media::where('user_uid', $user->uid)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($items);
    }

    /**
     * 4) Deletar mídia pertencente ao usuário autenticado (JWT).
     */
    public function destroy(Request $request, $id)
    {
        $user = $request->user();
        $media = Media::where('id', $id)
            ->where('user_uid', $user->uid)
            ->firstOrFail();

        // O arquivo físico será removido pelo evento deleting em Media::deleteStorage()
        $media->delete();

        return response()->json(null, 204);
    }

    /**
     * 5) Gerar URL temporária (presigned GET) para visualizar uma mídia.
     */
    public function generateViewUrl(Request $request)
    {
        $request->validate([
            'path' => 'required|string',
        ]);

        $user = $request->user();

        if (!str_starts_with($request->path, "users/{$user->uid}/")) {
            abort(403);
        }

        return response()->json([
            'url' => $this->gcs->getPresignedGetUrl($request->path, 3600),
        ]);
    }
}
