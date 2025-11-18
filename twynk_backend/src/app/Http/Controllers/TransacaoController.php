<?php

namespace App\Http\Controllers;

use App\Models\Transacao;
use Illuminate\Http\Request;

class TransacaoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Transacao::with(['usuario', 'plano']);

        if ($request->has('usuario_id')) {
            $query->where('usuario_id', $request->usuario_id);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('metodo_pagamento')) {
            $query->where('metodo_pagamento', $request->metodo_pagamento);
        }

        $transacoes = $query->orderBy('data_pagamento', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json($transacoes);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'usuario_id' => 'required|exists:users,id',
            'plano_id' => 'nullable|exists:planos,id',
            'valor_pago' => 'required|numeric|min:0',
            'metodo_pagamento' => 'required|in:mpesa,emola,paypal,stripe,outro',
            'status' => 'sometimes|in:pago,pendente,falhou',
        ]);

        $transacao = Transacao::create($validated);

        return response()->json($transacao, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $transacao = Transacao::with(['usuario', 'plano'])->findOrFail($id);

        return response()->json($transacao);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $transacao = Transacao::findOrFail($id);

        $validated = $request->validate([
            'status' => 'sometimes|in:pago,pendente,falhou',
            'metodo_pagamento' => 'sometimes|in:mpesa,emola,paypal,stripe,outro',
        ]);

        $transacao->update($validated);

        return response()->json($transacao);
    }
}

