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
            // Dados básicos
            'nome'          => 'sometimes|string|max:100',
            'apelido'       => 'sometimes|nullable|string|max:100',
            'genero'        => 'sometimes|in:masculino,feminino,outro',
            'sexualidade'   => 'sometimes|nullable|string|max:50',
            'interesse'     => 'sometimes|in:masculino,feminino,ambos',
            'estado_civil'  => 'sometimes|nullable|string|max:50',
            'data_nascimento' => 'sometimes|nullable|date',
            'signo'         => 'sometimes|nullable|string|max:50',
            'email' => [
                'sometimes',
                'email',
                'max:150',
                Rule::unique('users', 'email')->ignore($usuario->id),
            ],
            'google_id' => [
                'sometimes',
                'nullable',
                'string',
                'max:255',
                Rule::unique('users', 'google_id')->ignore($usuario->id),
            ],
            'password'      => 'sometimes|nullable|string|min:6',

            // Preferências de relacionamento / busca
            'tipo_relacionamento' => 'sometimes|nullable|string|max:50',
            'busca_genero'        => 'sometimes|nullable|string|max:50',
            'busca_idade_min'     => 'sometimes|nullable|integer|min:0',
            'busca_idade_max'     => 'sometimes|nullable|integer|min:0',
            'busca_distancia'     => 'sometimes|nullable|integer|min:0',

            // Dados pessoais adicionais
            'filhos'        => 'sometimes|nullable|integer|min:0',
            'escolaridade'  => 'sometimes|nullable|string|max:100',
            'profissao'     => 'sometimes|nullable|string|max:150',
            'religiao'      => 'sometimes|nullable|string|max:100',
            'humor'         => 'sometimes|nullable|string|max:100',

            // Localização normalizada
            'pais_id'       => 'sometimes|nullable|exists:pais,id',
            'provincia_id'  => 'sometimes|nullable|exists:provincia,id',
            'cidade_id'     => 'sometimes|nullable|exists:cidade,id',
            'mora_com'      => 'sometimes|nullable|string|max:100',

            // Aparência física
            'cor_pele'      => 'sometimes|nullable|string|max:50',
            'cor_olhos'     => 'sometimes|nullable|string|max:50',
            'cor_cabelos'   => 'sometimes|nullable|string|max:50',
            'altura'        => 'sometimes|nullable|numeric',
            'peso'          => 'sometimes|nullable|numeric',

            // Hábitos e estilo de vida
            'pratica_esporte' => 'sometimes|nullable|boolean',
            'fuma'            => 'sometimes|nullable|boolean',
            'bebe'            => 'sometimes|nullable|boolean',
            'como_me_considero_fisicamente' => 'sometimes|nullable|string',

            // Coordenadas de GPS
            'latitude'      => 'sometimes|nullable|numeric',
            'longitude'     => 'sometimes|nullable|numeric',

            // Status e plano
            'status'        => 'sometimes|in:ativo,inativo,banido',
            'plano_id'      => 'sometimes|nullable|exists:planos,id',
            'plano_expira_em' => 'sometimes|nullable|date',
            'limite_solicitacoes' => 'sometimes|nullable|integer|min:0',

            // Campos legados opcionais (caso ainda existam na tabela)
            'foto_perfil'   => 'sometimes|nullable|string|max:255',
            'bio'           => 'sometimes|nullable|string',
            'localizacao'   => 'sometimes|nullable|string|max:255',
        ]);

        if (isset($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        $usuario->update($validated);

        return response()->json($usuario);
    }

    /**
     * Update the profile of the currently authenticated user.
     *
     * This is a convenience wrapper around the generic update method,
     * allowing the frontend to call PUT /api/profile without needing
     * to know the user ID explicitly.
     */
    public function updateProfile(Request $request)
    {
        $user = $request->user();

        if (!$user) {
            return response()->json(['message' => 'Não autenticado'], 401);
        }

        return $this->update($request, $user->id);
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

