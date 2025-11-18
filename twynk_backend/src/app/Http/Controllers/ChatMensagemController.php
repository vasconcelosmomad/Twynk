<?php

namespace App\Http\Controllers;

use App\Models\ChatMensagem;
use Illuminate\Http\Request;

class ChatMensagemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = ChatMensagem::with(['remetente', 'destinatario']);

        if ($request->has('chat_id')) {
            $query->where('chat_id', $request->chat_id);
        }

        if ($request->has('remetente_id')) {
            $query->where('remetente_id', $request->remetente_id);
        }

        if ($request->has('destinatario_id')) {
            $query->where('destinatario_id', $request->destinatario_id);
        }

        if ($request->has('tipo')) {
            $query->where('tipo', $request->tipo);
        }

        $mensagens = $query->orderBy('data_envio', 'asc')
            ->paginate($request->get('per_page', 50));

        return response()->json($mensagens);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'chat_id' => 'required|string|max:100',
            'remetente_id' => 'required|exists:users,id',
            'destinatario_id' => 'required|exists:users,id|different:remetente_id',
            'tipo' => 'required|in:texto,imagem,audio,video',
            'conteudo' => 'required|string',
        ]);

        $mensagem = ChatMensagem::create($validated);

        return response()->json($mensagem, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $mensagem = ChatMensagem::with(['remetente', 'destinatario'])->findOrFail($id);

        return response()->json($mensagem);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $mensagem = ChatMensagem::findOrFail($id);
        $mensagem->delete();

        return response()->json(['message' => 'Mensagem deletada com sucesso'], 200);
    }
}

