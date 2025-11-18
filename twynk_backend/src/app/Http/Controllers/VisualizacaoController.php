<?php

namespace App\Http\Controllers;

use App\Models\Visualizacao;
use Illuminate\Http\Request;

class VisualizacaoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Visualizacao::with(['visualizador', 'visualizado']);

        if ($request->has('visualizador_id')) {
            $query->where('id_visualizador', $request->visualizador_id);
        }

        if ($request->has('visualizado_id')) {
            $query->where('id_visualizado', $request->visualizado_id);
        }

        $visualizacoes = $query->orderBy('data_visualizacao', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($visualizacoes);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'id_visualizador' => 'required|exists:users,id',
            'id_visualizado' => 'required|exists:users,id|different:id_visualizador',
        ]);

        $visualizacao = Visualizacao::create($validated);

        return response()->json($visualizacao, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $visualizacao = Visualizacao::with(['visualizador', 'visualizado'])->findOrFail($id);

        return response()->json($visualizacao);
    }
}

