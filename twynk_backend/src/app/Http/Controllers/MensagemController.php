<?php

namespace App\Http\Controllers;

use App\Models\Mensagem;
use Illuminate\Http\Request;

class MensagemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Mensagem::with(['remetente', 'destinatario']);

        if ($request->has('remetente_id')) {
            $query->where('remetente_id', $request->remetente_id);
        }

        if ($request->has('destinatario_id')) {
            $query->where('destinatario_id', $request->destinatario_id);
        }

        if ($request->has('lida')) {
            $query->where('lida', $request->boolean('lida'));
        }

        $mensagens = $query->orderBy('data_envio', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($mensagens);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'remetente_id' => 'required|exists:users,id',
            'destinatario_id' => 'required|exists:users,id|different:remetente_id',
            'conteudo' => 'required|string',
        ]);

        $mensagem = Mensagem::create($validated);

        return response()->json($mensagem, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $mensagem = Mensagem::with(['remetente', 'destinatario'])->findOrFail($id);

        return response()->json($mensagem);
    }

    /**
     * Marcar mensagem como lida
     */
    public function marcarComoLida($id)
    {
        $mensagem = Mensagem::findOrFail($id);
        $mensagem->update(['lida' => true]);

        return response()->json($mensagem);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $mensagem = Mensagem::findOrFail($id);
        $mensagem->delete();

        return response()->json(['message' => 'Mensagem deletada com sucesso'], 200);
    }
}

