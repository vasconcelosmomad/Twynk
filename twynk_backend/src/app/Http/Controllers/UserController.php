<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = User::with(['plano', 'creditos']);

        // Filtros
        if ($request->has('genero')) {
            $query->where('genero', $request->genero);
        }

        if ($request->has('interesse')) {
            $query->where('interesse', $request->interesse);
        }

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        $usuarios = $query->paginate($request->get('per_page', 15));

        return response()->json($usuarios);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nome' => 'required|string|max:100',
            'genero' => 'required|in:masculino,feminino,outro',
            'interesse' => 'nullable|in:masculino,feminino,ambos',
            'data_nascimento' => 'nullable|date',
            'email' => 'required|email|unique:users,email|max:150',
            'password' => 'nullable|string|min:6',
            'foto_perfil' => 'nullable|string|max:255',
            'bio' => 'nullable|string',
            'localizacao' => 'nullable|string|max:100',
            'plano_id' => 'nullable|exists:planos,id',
        ]);

        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        $usuario = User::create($validated);

        return response()->json($usuario, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $usuario = User::with([
            'plano',
            'plano.beneficios',
            'creditos',
            'assinaturas',
            'fotos',
            'statusPublicacoes'
        ])->findOrFail($id);

        return response()->json($usuario);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $usuario = User::findOrFail($id);

        $validated = $request->validate([
            'nome' => 'sometimes|string|max:100',
            'genero' => 'sometimes|in:masculino,feminino,outro',
            'interesse' => 'sometimes|in:masculino,feminino,ambos',
            'data_nascimento' => 'nullable|date',
            'email' => ['sometimes', 'email', Rule::unique('users')->ignore($usuario->id), 'max:150'],
            'google_id' => ['nullable', 'string', 'max:255', Rule::unique('users')->ignore($usuario->id)],
            'password' => 'sometimes|string|min:6',
            'foto_perfil' => 'nullable|string|max:255',
            'bio' => 'nullable|string',
            'localizacao' => 'nullable|string|max:255',
            'status' => 'sometimes|in:ativo,inativo,banido',
            'plano_id' => 'nullable|exists:planos,id',
        ]);

        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        $usuario->update($validated);

        return response()->json($usuario);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $usuario = User::findOrFail($id);
        $usuario->delete();

        return response()->json(['message' => 'Usuário deletado com sucesso'], 200);
    }
}

