<?php

namespace App\Http\Controllers;

use App\Models\Media;
use App\Services\PresignService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class MediaController extends Controller
{
    /**
     * Serviço responsável por gerar URLs presignadas.
     */
    protected PresignService $presign;

    public function __construct(PresignService $presign)
    {
        $this->presign = $presign;
    }

    /**
     * 1) Gera presigned URL para upload.
     *
     * Organiza os arquivos em pastas por tipo:
     * - profile: users/{uid}/profile/
     * - image  : users/{uid}/images/
     * - video  : users/{uid}/videos/
     * - chat   : users/{uid}/chats/
     */
    public function presign(Request $request)
    {
        $request->validate([
            'filename' => 'required|string',
            'contentType' => 'required|string',
            'type' => 'required|in:image,video,profile,chat',
        ]);

        $uid = $request->get('user_uid'); // definido pelo middleware firebase.auth

        $type = $request->input('type');
        $ext = pathinfo($request->input('filename'), PATHINFO_EXTENSION);

        // Mapeia o tipo lógico para a pasta física no bucket
        $folder = match ($type) {
            'profile' => "users/{$uid}/profile/",
            'image'   => "users/{$uid}/images/",
            'video'   => "users/{$uid}/videos/",
            'chat'    => "users/{$uid}/chats/",
            default   => "users/{$uid}/others/",
        };

        $filename = time() . '-' . Str::uuid() . ($ext ? ".{$ext}" : '');
        $key = $folder . $filename;

        $url = $this->presign->getPresignedPutUrl(
            $key,
            $request->input('contentType')
        );

        return response()->json([
            'uploadUrl' => $url,
            'key' => $key,
            'path' => $key,
            'expires_in' => 300,
        ]);
    }

    /**
     * 2) Registrar metadados após upload.
     */
    public function register(Request $request)
    {
        $request->validate([
            'key' => 'required|string',
            'filename' => 'nullable|string',
            'size' => 'nullable|integer',
            'type' => 'required|string',
        ]);

        $uid = $request->get('user_uid');

        $media = Media::create([
            'user_uid' => $uid,
            'type' => $request->input('type'),
            'filename' => $request->input('filename'),
            'path' => $request->input('key'),
            'url' => null,
            'size' => $request->input('size'),
        ]);

        return response()->json($media, 201);
    }

    /**
     * 3) Listar mídias do usuário autenticado (Firebase).
     */
    public function index(Request $request)
    {
        $uid = $request->get('user_uid');

        $items = Media::where('user_uid', $uid)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($items);
    }

    /**
     * 4) Deletar mídia pertencente ao usuário.
     */
    public function destroy(Request $request, $id)
    {
        $uid = $request->get('user_uid');

        $media = Media::where('id', $id)
            ->where('user_uid', $uid)
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

        $url = $this->presign->getPresignedGetUrl(
            $request->input('path'),
            3600 // 1 hora
        );

        return response()->json([
            'url' => $url,
        ]);
    }
}
