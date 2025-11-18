<?php

namespace App\Http\Controllers;

use App\Models\Credito;
use Illuminate\Http\Request;

class CreditoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Credito::with('usuario');

        if ($request->has('usuario_id')) {
            $query->where('usuario_id', $request->usuario_id);
        }

        $creditos = $query->get();

        return response()->json($creditos);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'usuario_id' => 'required|exists:users,id',
            'saldo' => 'required|numeric|min:0',
        ]);

        $credito = Credito::create($validated);

        return response()->json($credito, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $credito = Credito::with('usuario')->findOrFail($id);

        return response()->json($credito);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $credito = Credito::findOrFail($id);

        $validated = $request->validate([
            'saldo' => 'sometimes|numeric|min:0',
        ]);

        $validated['ultimo_update'] = now();

        $credito->update($validated);

        return response()->json($credito);
    }

    /**
     * Adicionar créditos
     */
    public function adicionar(Request $request, $id)
    {
        $credito = Credito::findOrFail($id);

        $validated = $request->validate([
            'valor' => 'required|numeric|min:0',
        ]);

        $credito->saldo += $validated['valor'];
        $credito->ultimo_update = now();
        $credito->save();

        return response()->json($credito);
    }

    /**
     * Remover créditos
     */
    public function remover(Request $request, $id)
    {
        $credito = Credito::findOrFail($id);

        $validated = $request->validate([
            'valor' => 'required|numeric|min:0',
        ]);

        if ($credito->saldo < $validated['valor']) {
            return response()->json(['message' => 'Saldo insuficiente'], 400);
        }

        $credito->saldo -= $validated['valor'];
        $credito->ultimo_update = now();
        $credito->save();

        return response()->json($credito);
    }
}

