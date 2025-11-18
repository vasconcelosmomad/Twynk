<?php

namespace App\Http\Controllers;

use App\Models\SolicitacaoChat;
use Illuminate\Http\Request;

class SolicitacaoChatController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = SolicitacaoChat::with(['solicitante', 'solicitado']);

        if ($request->has('solicitante_id')) {
            $query->where('solicitante_id', $request->solicitante_id);
        }

        if ($request->has('solicitado_id')) {
            $query->where('solicitado_id', $request->solicitado_id);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        if ($request->has('tipo')) {
            $query->where('tipo', $request->tipo);
        }

        $solicitacoes = $query->orderBy('data_solicitacao', 'desc')
            ->paginate($request->get('per_page', 15));

        return response()->json($solicitacoes);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'solicitante_id' => 'required|exists:users,id',
            'solicitado_id' => 'required|exists:users,id|different:solicitante_id',
            'tipo' => 'required|in:chat,video',
            'status' => 'sometimes|in:pendente,aceito,recusado',
        ]);

        $solicitacao = SolicitacaoChat::create($validated);

        return response()->json($solicitacao, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $solicitacao = SolicitacaoChat::with(['solicitante', 'solicitado'])->findOrFail($id);

        return response()->json($solicitacao);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $solicitacao = SolicitacaoChat::findOrFail($id);

        $validated = $request->validate([
            'status' => 'required|in:pendente,aceito,recusado',
        ]);

        $solicitacao->update($validated);

        return response()->json($solicitacao);
    }

    /**
     * Aceitar solicitação
     */
    public function aceitar($id)
    {
        $solicitacao = SolicitacaoChat::findOrFail($id);
        $solicitacao->update(['status' => 'aceito']);

        return response()->json($solicitacao);
    }

    /**
     * Recusar solicitação
     */
    public function recusar($id)
    {
        $solicitacao = SolicitacaoChat::findOrFail($id);
        $solicitacao->update(['status' => 'recusado']);

        return response()->json($solicitacao);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $solicitacao = SolicitacaoChat::findOrFail($id);
        $solicitacao->delete();

        return response()->json(['message' => 'Solicitação deletada com sucesso'], 200);
    }
}

