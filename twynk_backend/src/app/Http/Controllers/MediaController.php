<?php

namespace App\Http\Controllers;

use App\Models\Media;
use App\Services\B2Service;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

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

        $request->validate([\n+            'type' => 'required|in:image,video,profile,chat',
            'file' => "required|file|max:$maxSize",
        ]);

        $mimeRules = [
            'image'   => ['image/jpeg', 'image/png', 'image/webp'],
            'profile' => ['image/jpeg', 'image/png', 'image/webp'],
            'video'   => ['video/mp4', 'video/webm'],
            'chat'    => ['image/jpeg', 'image/png', 'video/mp4'],
        ];

        $file = $request->file('file');

        if (!in_array($file->getMimeType(), $mimeRules[$request->type])) {
            return response()->json(['message' => 'Tipo de ficheiro não permitido'], 422);
        }

        $uid = $request->user()->uid;

        $folder = match ($request->type) {
            'profile' => "users/{$uid}/profile/",
            'image'   => "users/{$uid}/images/",
            'video'   => "users/{$uid}/videos/",
            'chat'    => "users/{$uid}/chats/",
        };

        $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();
        $path = $folder . $filename;

        try {
            $this->b2->uploadFile($file->getPathname(), $path, $file->getMimeType());
        } catch (\Throwable $e) {
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

        $items = Media::where('user_uid', $user->uid)
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($items);
    }

    public function destroy(Request $request, $id)
    {
        $media = Media::where('id', $id)
            ->where('user_uid', $request->user()->uid)
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
