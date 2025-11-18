<?php

namespace App\Http\Controllers;

use App\Models\Like;
use Illuminate\Http\Request;

class LikeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Like::with(['usuarioOrigem', 'usuarioDestino']);

        if ($request->has('usuario_origem_id')) {
            $query->where('id_usuario_origem', $request->usuario_origem_id);
        }

        if ($request->has('usuario_destino_id')) {
            $query->where('id_usuario_destino', $request->usuario_destino_id);
        }

        $likes = $query->orderBy('data_like', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json($likes);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'id_usuario_origem' => 'required|exists:users,id',
            'id_usuario_destino' => 'required|exists:users,id|different:id_usuario_origem',
        ]);

        // Verificar se já existe like
        $likeExistente = Like::where('id_usuario_origem', $validated['id_usuario_origem'])
            ->where('id_usuario_destino', $validated['id_usuario_destino'])
            ->first();

        if ($likeExistente) {
            return response()->json(['message' => 'Like já existe'], 409);
        }

        $like = Like::create($validated);

        return response()->json($like, 201);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $like = Like::findOrFail($id);
        $like->delete();

        return response()->json(['message' => 'Like removido com sucesso'], 200);
    }

    /**
     * Verificar match (like mútuo)
     */
    public function checkMatch(Request $request)
    {
        $validated = $request->validate([
            'usuario1_id' => 'required|exists:users,id',
            'usuario2_id' => 'required|exists:users,id',
        ]);

        $like1 = Like::where('id_usuario_origem', $validated['usuario1_id'])
            ->where('id_usuario_destino', $validated['usuario2_id'])
            ->exists();

        $like2 = Like::where('id_usuario_origem', $validated['usuario2_id'])
            ->where('id_usuario_destino', $validated['usuario1_id'])
            ->exists();

        return response()->json([
            'match' => $like1 && $like2,
            'like1' => $like1,
            'like2' => $like2,
        ]);
    }
}

