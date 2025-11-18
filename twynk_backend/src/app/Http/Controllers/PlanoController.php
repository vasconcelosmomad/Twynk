<?php

namespace App\Http\Controllers;

use App\Models\Plano;
use Illuminate\Http\Request;

class PlanoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Plano::with('beneficios');

        if ($request->has('ativo')) {
            $query->where('ativo', $request->boolean('ativo'));
        }

        if ($request->has('duracao')) {
            $query->where('duracao', $request->duracao);
        }

        $planos = $query->get();

        return response()->json($planos);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nome' => 'required|string|max:50',
            'descricao' => 'nullable|string',
            'duracao' => 'required|in:gratuito,semanal,quinzenal,mensal',
            'preco' => 'required|numeric|min:0',
            'ativo' => 'boolean',
        ]);

        $plano = Plano::create($validated);

        return response()->json($plano, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $plano = Plano::with('beneficios')->findOrFail($id);

        return response()->json($plano);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $plano = Plano::findOrFail($id);

        $validated = $request->validate([
            'nome' => 'sometimes|string|max:50',
            'descricao' => 'nullable|string',
            'duracao' => 'sometimes|in:gratuito,semanal,quinzenal,mensal',
            'preco' => 'sometimes|numeric|min:0',
            'ativo' => 'boolean',
        ]);

        $plano->update($validated);

        return response()->json($plano);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $plano = Plano::findOrFail($id);
        $plano->delete();

        return response()->json(['message' => 'Plano deletado com sucesso'], 200);
    }
}

