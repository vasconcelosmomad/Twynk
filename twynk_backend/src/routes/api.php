<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PaisController;
use App\Http\Controllers\ProvinciaController;
use App\Http\Controllers\CidadeController;
use App\Http\Controllers\LocationController;
use App\Http\Controllers\OtpController;

/*
|--------------------------------------------------------------------------
| Rotas Públicas
|--------------------------------------------------------------------------
*/

// Rotas de autenticação públicas
Route::post('login', [AuthController::class, 'login']);
Route::post('register', [AuthController::class, 'register']);
Route::post('login/google', [AuthController::class, 'loginGoogle']);

// OTP
Route::post('/otp/send', [OtpController::class, 'gerarOtp']);
Route::post('/otp/verify', [OtpController::class, 'verificarOtp']);

// Recursos públicos (apenas leitura)
Route::apiResource('paises', PaisController::class)->only(['index','show']);
Route::apiResource('provincias', ProvinciaController::class)->only(['index','show']);
Route::apiResource('cidades', CidadeController::class)->only(['index','show']);

// Dropdown dependentes
Route::get('paises/{pais_id}/provincias', [LocationController::class, 'getProvincias']);
Route::get('provincias/{provincia_id}/cidades', [LocationController::class, 'getCidades']);

/*
|--------------------------------------------------------------------------
| Rotas Protegidas (JWT)
|--------------------------------------------------------------------------
*/

Route::middleware('auth:api')->group(function () {

    // Usuário logado
    Route::get('/user', function (Request $request) {
        return response()->json([
            'success' => true,
            'data' => $request->user()
        ]);
    });

    // Perfil e logout
    Route::get('profile', [AuthController::class, 'profile']);
    Route::post('logout', [AuthController::class, 'logout']);

    // CRUD protegido de paises, provincias e cidades
    Route::apiResource('paises', PaisController::class)->except(['index','show']);
    Route::apiResource('provincias', ProvinciaController::class)->except(['index','show']);
    Route::apiResource('cidades', CidadeController::class)->except(['index','show']);
});
