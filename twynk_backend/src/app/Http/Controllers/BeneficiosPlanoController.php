<?php

namespace App\Http\Controllers;

use App\Models\BeneficiosPlano;
use Illuminate\Http\Request;

class BeneficiosPlanoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = BeneficiosPlano::with('plano');

        if ($request->has('plano_id')) {
            $query->where('plano_id', $request->plano_id);
        }

        $beneficios = $query->get();

        return response()->json($beneficios);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'plano_id' => 'required|exists:planos,id',
            'curtidas_dia' => 'integer|min:0',
            'mensagens_dia' => 'integer|min:0',
            'video_tempo_min' => 'integer|min:0',
            'boost_semana' => 'integer|min:0',
            'pode_chat' => 'boolean',
            'pode_video' => 'boolean',
            'ver_quem_curtiu' => 'boolean',
            'enviar_fotos' => 'boolean',
            'creditos_iniciais' => 'numeric|min:0',
            'suporte_prioritario' => 'boolean',
        ]);

        $beneficios = BeneficiosPlano::create($validated);

        return response()->json($beneficios, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $beneficios = BeneficiosPlano::with('plano')->findOrFail($id);

        return response()->json($beneficios);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $beneficios = BeneficiosPlano::findOrFail($id);

        $validated = $request->validate([
            'curtidas_dia' => 'sometimes|integer|min:0',
            'mensagens_dia' => 'sometimes|integer|min:0',
            'video_tempo_min' => 'sometimes|integer|min:0',
            'boost_semana' => 'sometimes|integer|min:0',
            'pode_chat' => 'boolean',
            'pode_video' => 'boolean',
            'ver_quem_curtiu' => 'boolean',
            'enviar_fotos' => 'boolean',
            'creditos_iniciais' => 'sometimes|numeric|min:0',
            'suporte_prioritario' => 'boolean',
        ]);

        $beneficios->update($validated);

        return response()->json($beneficios);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $beneficios = BeneficiosPlano::findOrFail($id);
        $beneficios->delete();

        return response()->json(['message' => 'Benefícios deletados com sucesso'], 200);
    }
}

