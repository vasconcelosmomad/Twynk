<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Otp;
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
            'nome'              => 'required|string|max:100',
            'apelido'           => 'nullable|string|max:100',
            'genero'            => 'required|in:masculino,feminino,outro',
            'interesse'         => 'nullable|in:masculino,feminino,ambos',
            'data_nascimento'   => 'required|date',
            'email'             => 'required|email|unique:users,email|max:150',
            'password'          => 'required|string|min:6',
            'otp'               => 'required|digits:6',
            // Dados adicionais opcionais
            'cor_pele'          => 'nullable|string|max:50',
            'escolaridade'      => 'nullable|string|max:100',
            'pais_id'           => 'nullable|integer',
            'provincia_id'      => 'nullable|integer',
            'cidade_id'         => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'errors' => $validator->errors()
            ], 422);
        }

        // Verificação obrigatória de OTP antes do cadastro
        $otp = Otp::where('email', $request->email)
            ->where('otp', $request->otp)
            ->first();

        if (!$otp) {
            return response()->json([
                'error' => 'Código OTP inválido.',
            ], 400);
        }

        if (now()->greaterThan($otp->expires_at)) {
            $otp->delete();

            return response()->json([
                'error' => 'Código OTP expirado.',
            ], 400);
        }

        // Consome o OTP após uso bem-sucedido
        $otp->delete();

        $user = User::create([
            'nome'            => $request->nome,
            'apelido'         => $request->apelido,
            'genero'          => $request->genero,
            'interesse'       => $request->interesse ?? 'ambos',
            'data_nascimento' => $request->data_nascimento,
            'email'           => $request->email,
            'password'        => Hash::make($request->password),
            'cor_pele'        => $request->cor_pele,
            'escolaridade'    => $request->escolaridade,
            'pais_id'         => $request->pais_id,
            'provincia_id'    => $request->provincia_id,
            'cidade_id'       => $request->cidade_id,
            'status'          => 'ativo',
        ]);

        $token = JWTAuth::fromUser($user);

        return response()->json([
            'token' => $token,
            'user'  => $user
        ], 201);
    }

    /**
     * Login with email and password
     */
    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        $validator = Validator::make($credentials, [
            'email'    => 'required|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            if (!$token = JWTAuth::attempt($credentials)) {
                return response()->json(['error' => 'Credenciais inválidas'], 401);
            }
        } catch (JWTException $e) {
            return response()->json(['error' => 'Não foi possível criar o token'], 500);
        }

        return response()->json([
            'token' => $token,
            'user'  => auth()->user()
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
            return response()->json(['errors' => $validator->errors()], 422);
        }

        try {
            $googleUser = Socialite::driver('google')
                ->stateless()
                ->userFromToken($request->idToken);

            $user = User::firstOrCreate(
                ['google_id' => $googleUser->id],
                [
                    'nome'            => $googleUser->name,
                    'apelido'         => null,
                    'email'           => $googleUser->email,
                    'genero'          => 'outro',
                    'interesse'       => 'ambos',
                    'data_nascimento' => now()->subYears(18),
                    'status'          => 'ativo',
                ]
            );

            $token = JWTAuth::fromUser($user);

            return response()->json([
                'token' => $token,
                'user'  => $user
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Erro ao autenticar com Google'
            ], 401);
        }
    }

    /**
     * Get authenticated user profile
     */
    public function profile()
    {
        return response()->json(auth()->user());
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
