<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PaisController;
use App\Http\Controllers\ProvinciaController;
use App\Http\Controllers\CidadeController;
use App\Http\Controllers\LocationController;
use App\Http\Controllers\OtpController;
use App\Http\Controllers\MediaController;
use App\Http\Controllers\UserController;

/*
|--------------------------------------------------------------------------
| Rotas Públicas (Sem Autenticação)
|--------------------------------------------------------------------------
*/

// Autenticação
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login/google', [AuthController::class, 'loginGoogle']);

// OTP
Route::post('/otp/send', [OtpController::class, 'gerarOtp']);
Route::post('/otp/verify', [OtpController::class, 'verificarOtp']);

// Listagem pública dos recursos
Route::apiResource('paises', PaisController::class)->only(['index', 'show']);
Route::apiResource('provincias', ProvinciaController::class)->only(['index', 'show']);
Route::apiResource('cidades', CidadeController::class)->only(['index', 'show']);

// Relacionamentos (RESTful)
Route::get('/paises/{pais}/provincias', [LocationController::class, 'getProvincias']);
Route::get('/provincias/{provincia}/cidades', [LocationController::class, 'getCidades']);

/*
|--------------------------------------------------------------------------
| Rotas Protegidas (JWT)
|--------------------------------------------------------------------------
*/

Route::get('/cors-test', function () {
    return response()->json(['ok' => true]);
});


Route::middleware('auth:api')->group(function () {

    // Informações do usuário autenticado
    Route::get('/user', fn(Request $request) => response()->json([
        'success' => true,
        'data' => $request->user()
    ]));

    // Perfil e logout
    Route::get('/profile', [AuthController::class, 'profile']);
    Route::put('/profile', [UserController::class, 'updateProfile']);
    Route::post('/logout', [AuthController::class, 'logout']);

    // CRUD protegido completo para paises / provincias / cidades
    Route::apiResource('paises', PaisController::class)->except(['index','show']);
    Route::apiResource('provincias', ProvinciaController::class)->except(['index','show']);
    Route::apiResource('cidades', CidadeController::class)->except(['index','show']);

    // Rotas de mídia agora também usam JWT (auth:api)
    Route::post('/upload', [MediaController::class, 'upload']);
    Route::get('/media', [MediaController::class, 'index']);
    Route::delete('/media/{id}', [MediaController::class, 'destroy']);

    // URL temporária para visualização
    Route::get('/media/view-url', [MediaController::class, 'generateViewUrl']);
});
