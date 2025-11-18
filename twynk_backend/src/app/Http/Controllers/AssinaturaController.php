<?php

namespace App\Http\Controllers;

use App\Models\Assinatura;
use Illuminate\Http\Request;

class AssinaturaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Assinatura::with(['usuario', 'plano']);

        if ($request->has('usuario_id')) {
            $query->where('usuario_id', $request->usuario_id);
        }

        if ($request->has('ativo')) {
            $query->where('ativo', $request->boolean('ativo'));
        }

        $assinaturas = $query->paginate($request->get('per_page', 15));

        return response()->json($assinaturas);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'usuario_id' => 'required|exists:users,id',
            'plano_id' => 'required|exists:planos,id',
            'data_inicio' => 'nullable|date',
            'data_fim' => 'nullable|date|after:data_inicio',
            'ativo' => 'boolean',
        ]);

        $assinatura = Assinatura::create($validated);

        return response()->json($assinatura, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $assinatura = Assinatura::with(['usuario', 'plano', 'plano.beneficios'])->findOrFail($id);

        return response()->json($assinatura);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $assinatura = Assinatura::findOrFail($id);

        $validated = $request->validate([
            'plano_id' => 'sometimes|exists:planos,id',
            'data_inicio' => 'nullable|date',
            'data_fim' => 'nullable|date|after:data_inicio',
            'ativo' => 'boolean',
        ]);

        $assinatura->update($validated);

        return response()->json($assinatura);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $assinatura = Assinatura::findOrFail($id);
        $assinatura->delete();

        return response()->json(['message' => 'Assinatura deletada com sucesso'], 200);
    }
}

