<?php

namespace App\Http\Middleware;

use Illuminate\Auth\Middleware\Authenticate as Middleware;

class Authenticate extends Middleware
{
    /**
     * Define para onde redirecionar usuários não autenticados.
     *
     * Para a API (requests que esperam JSON ou começam com /api),
     * não fazemos redirect para rota "login" (que nem existe na API),
     * apenas deixamos o Laravel retornar 401 JSON.
     */
    protected function redirectTo($request): ?string
    {
        if ($request->expectsJson() || $request->is('api/*')) {
            return null;
        }

        // Se no futuro você tiver uma rota web de login, pode trocar aqui por:
        // return route('login');
        return null;
    }
}
