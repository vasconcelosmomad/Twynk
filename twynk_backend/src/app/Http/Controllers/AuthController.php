<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Tymon\JWTAuth\Facades\JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Laravel\Socialite\Facades\Socialite;

class AuthController extends Controller
{
    /**
     * Register a new user
     */
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nome' => 'required|string|max:100',
            'genero' => 'required|in:masculino,feminino,outro',
            'interesse' => 'nullable|in:masculino,feminino,ambos',
            'data_nascimento' => 'required|date',
            'email' => 'required|email|unique:users,email|max:150',
            'password' => 'required|string|min:6',
            'foto_perfil' => 'nullable|string|max:255',
            'bio' => 'nullable|string',
            'localizacao' => 'nullable|string|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }

        $user = User::create([
            'nome' => $request->nome,
            'genero' => $request->genero,
            'interesse' => $request->interesse ?? 'ambos',
            'data_nascimento' => $request->data_nascimento,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'foto_perfil' => $request->foto_perfil,
            'bio' => $request->bio,
            'localizacao' => $request->localizacao,
            'status' => 'ativo',
        ]);

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'token' => $token,
            'user' => $user
        ], 201);
    }

    /**
     * Login with email and password
     */
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        $validator = Validator::make($credentials, [
            'email' => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }

        try {
            if (!$token = JWTAuth::attempt($credentials)) {
                return response()->json(['error' => 'Credenciais inválidas'], 401);
            }
        } catch (JWTException $e) {
            return response()->json(['error' => 'Não foi possível criar o token'], 500);
        }

        $user = auth()->user();

        return response()->json([
            'token' => $token,
            'user' => $user
        ]);
    }

    /**
     * Login with Google
     */
    public function loginGoogle(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'idToken' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['error' => $validator->errors()], 400);
        }

        try {
            $googleUser = Socialite::driver('google')->stateless()->userFromToken($request->idToken);

            $user = User::firstOrCreate(
                ['google_id' => $googleUser->id],
                [
                    'nome' => $googleUser->name,
                    'email' => $googleUser->email,
                    'foto_perfil' => $googleUser->avatar,
                    'genero' => 'outro', // Default, pode ser atualizado depois
                    'interesse' => 'ambos',
                    'data_nascimento' => now()->subYears(18), // Default, deve ser atualizado
                    'status' => 'ativo',
                ]
            );

            $token = JWTAuth::fromUser($user);

            return response()->json([
                'token' => $token,
                'user' => $user
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Erro ao autenticar com Google: ' . $e->getMessage()], 401);
        }
    }

    /**
     * Get authenticated user profile
     */
    public function profile()
    {
        try {
            $user = auth()->user();
            return response()->json($user);
        } catch (JWTException $e) {
            return response()->json(['error' => 'Token inválido'], 401);
        }
    }

    /**
     * Logout user
     */
    public function logout()
    {
        try {
            JWTAuth::invalidate(JWTAuth::getToken());
            return response()->json(['message' => 'Logout efetuado com sucesso']);
        } catch (JWTException $e) {
            return response()->json(['error' => 'Erro ao fazer logout'], 500);
        }
    }

    /**
     * Refresh token
     */
    public function refresh()
    {
        try {
            $token = JWTAuth::refresh(JWTAuth::getToken());
            return response()->json(['token' => $token]);
        } catch (JWTException $e) {
            return response()->json(['error' => 'Não foi possível atualizar o token'], 401);
        }
    }
}

