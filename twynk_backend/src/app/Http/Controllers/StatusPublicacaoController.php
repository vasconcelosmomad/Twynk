<?php

namespace App\Http\Controllers;

use App\Models\StatusPublicacao;
use Illuminate\Http\Request;

class StatusPublicacaoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = StatusPublicacao::with('usuario');

        if ($request->has('usuario_id')) {
            $query->where('usuario_id', $request->usuario_id);
        }

        $publicacoes = $query->orderBy('data_publicacao', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($publicacoes);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'usuario_id' => 'required|exists:users,id',
            'texto' => 'nullable|string',
            'imagem_url' => 'nullable|string|max:255',
        ]);

        $publicacao = StatusPublicacao::create($validated);

        return response()->json($publicacao, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $publicacao = StatusPublicacao::with('usuario')->findOrFail($id);

        return response()->json($publicacao);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $publicacao = StatusPublicacao::findOrFail($id);

        $validated = $request->validate([
            'texto' => 'nullable|string',
            'imagem_url' => 'nullable|string|max:255',
        ]);

        $publicacao->update($validated);

        return response()->json($publicacao);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $publicacao = StatusPublicacao::findOrFail($id);
        $publicacao->delete();

        return response()->json(['message' => 'Publicação deletada com sucesso'], 200);
    }
}

