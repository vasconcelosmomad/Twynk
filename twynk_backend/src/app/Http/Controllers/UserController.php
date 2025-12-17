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
        if ($request->filled('genero')) {
            $query->where('genero', $request->genero);
        }

        if ($request->filled('interesse')) {
            $query->where('interesse', $request->interesse);
        }

        if ($request->filled('status')) {
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
            // Dados básicos
            'nome'              => 'required|string|max:100',
            'apelido'           => 'nullable|string|max:100',
            'genero'            => 'required|in:masculino,feminino,outro',
            'sexualidade'       => 'nullable|string|max:50',
            'interesse'         => 'nullable|in:masculino,feminino,ambos',
            'estado_civil'      => 'nullable|string|max:50',
            'data_nascimento'   => 'required|date',
            'signo'             => 'nullable|string|max:50',
            'email'             => 'required|email|unique:users,email|max:150',
            'password'          => 'nullable|string|min:6',
            'google_id'         => 'nullable|string|max:255|unique:users,google_id',
            'is_verified'       => 'nullable|boolean',
            'is_banned'         => 'nullable|boolean',
            'motivo_banamento'  => 'nullable|string|max:255',
            'motivo_banimento'  => 'nullable|string|max:255',
            'ultimo_login'      => 'nullable|date',
            'role'              => 'nullable|in:user,admin,support',

            // Preferências de relacionamento / busca
            'tipo_relacionamento' => 'nullable|string|max:50',
            'busca_genero'        => 'nullable|string|max:50',
            'busca_idade_min'     => 'nullable|integer|min:0',
            'busca_idade_max'     => 'nullable|integer|min:0',
            'busca_distancia'     => 'nullable|integer|min:0',

            // Dados pessoais adicionais
            'filhos'        => 'nullable|integer|min:0',
            'escolaridade'  => 'nullable|string|max:100',
            'profissao'     => 'nullable|string|max:150',
            'religiao'      => 'nullable|string|max:100',
            'humor'         => 'nullable|string|max:100',

            // Localização normalizada
            'pais_id'       => 'nullable|exists:pais,id',
            'provincia_id'  => 'nullable|exists:provincia,id',
            'cidade_id'     => 'nullable|exists:cidade,id',
            'mora_com'      => 'nullable|string|max:100',

            // Aparência física
            'cor_pele'      => 'nullable|string|max:50',
            'cor_olhos'     => 'nullable|string|max:50',
            'cor_cabelos'   => 'nullable|string|max:50',
            'altura'        => 'nullable|numeric',
            'peso'          => 'nullable|numeric',

            // Hábitos e estilo de vida
            'pratica_esporte' => 'nullable|boolean',
            'fuma'            => 'nullable|boolean',
            'bebe'            => 'nullable|boolean',
            'como_me_considero_fisicamente' => 'nullable|string',

            // Coordenadas de GPS
            'latitude'      => 'nullable|numeric',
            'longitude'     => 'nullable|numeric',

            // Status e plano
            'status'            => 'nullable|in:ativo,inativo,banido',
            'plano_id'          => 'nullable|exists:planos,id',
            'plano_expira_em'   => 'nullable|date',
            'limite_solicitacoes' => 'nullable|integer|min:0',
        ]);

        if (!empty($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        if (!empty($validated['motivo_banimento']) && empty($validated['motivo_banamento'])) {
            $validated['motivo_banamento'] = $validated['motivo_banimento'];
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

            'is_verified'   => 'sometimes|boolean',
            'is_banned'     => 'sometimes|boolean',
            'motivo_banamento' => 'sometimes|nullable|string|max:255',
            'motivo_banimento' => 'sometimes|nullable|string|max:255',
            'ultimo_login'  => 'sometimes|nullable|date',
            'role'          => 'sometimes|nullable|in:user,admin,support',

            'password' => 'sometimes|nullable|string|min:6',

            // Preferências
            'tipo_relacionamento' => 'sometimes|nullable|string|max:50',
            'busca_genero'        => 'sometimes|nullable|string|max:50',
            'busca_idade_min'     => 'sometimes|nullable|integer|min:0',
            'busca_idade_max'     => 'sometimes|nullable|integer|min:0',
            'busca_distancia'     => 'sometimes|nullable|integer|min:0',

            // Dados pessoais
            'filhos'        => 'sometimes|nullable|integer|min:0',
            'escolaridade'  => 'sometimes|nullable|string|max:100',
            'profissao'     => 'sometimes|nullable|string|max:150',
            'religiao'      => 'sometimes|nullable|string|max:100',
            'humor'         => 'sometimes|nullable|string|max:100',

            // Localização
            'pais_id'       => 'sometimes|nullable|exists:pais,id',
            'provincia_id'  => 'sometimes|nullable|exists:provincia,id',
            'cidade_id'     => 'sometimes|nullable|exists:cidade,id',
            'mora_com'      => 'sometimes|nullable|string|max:100',

            // Aparência
            'cor_pele'      => 'sometimes|nullable|string|max:50',
            'cor_olhos'     => 'sometimes|nullable|string|max:50',
            'cor_cabelos'   => 'sometimes|nullable|string|max:50',
            'altura'        => 'sometimes|nullable|numeric',
            'peso'          => 'sometimes|nullable|numeric',

            // Hábitos
            'pratica_esporte' => 'sometimes|nullable|boolean',
            'fuma'            => 'sometimes|nullable|boolean',
            'bebe'            => 'sometimes|nullable|boolean',
            'como_me_considero_fisicamente' => 'sometimes|nullable|string',

            // GPS
            'latitude'      => 'sometimes|nullable|numeric',
            'longitude'     => 'sometimes|nullable|numeric',

            // Status / Plano
            'status'        => 'sometimes|in:ativo,inativo,banido',
            'plano_id'      => 'sometimes|nullable|exists:planos,id',
            'plano_expira_em' => 'sometimes|nullable|date',
            'limite_solicitacoes' => 'sometimes|nullable|integer|min:0',
        ]);

        if (!empty($validated['password'])) {
            $validated['password'] = Hash::make($validated['password']);
        }

        if (!empty($validated['motivo_banimento']) && empty($validated['motivo_banamento'])) {
            $validated['motivo_banamento'] = $validated['motivo_banimento'];
        }

        $usuario->update($validated);

        return response()->json($usuario);
    }

    /**
     * Update profile of authenticated user
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
     * Remove the specified resource.
     */
    public function destroy($id)
    {
        $usuario = User::findOrFail($id);
        $usuario->delete();

        return response()->json(['message' => 'Usuário deletado com sucesso']);
    }
}
