<?php

namespace App\Http\Controllers;

use App\Models\Otp;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;

class OtpController extends Controller
{
    private int $expirationMinutes = 5;

    public function gerarOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        // Não permitir envio de OTP para emails já cadastrados na tabela users
        if (User::where('email', $request->email)->exists()) {
            return response()->json([
                'message' => 'Este email já está associado a uma conta.',
            ], 400);
        }

        $codigo = rand(100000, 999999);

        Otp::where('email', $request->email)->delete();

        Otp::create([
            'email' => $request->email,
            'otp' => $codigo,
            'expires_at' => Carbon::now()->addMinutes($this->expirationMinutes),
        ]);

        Mail::raw(
            "Seu código OTP é {$codigo}. Ele é válido por {$this->expirationMinutes} minutos.",
            function ($message) use ($request) {
                $message->to($request->email)
                    ->subject('Código OTP - Nomirro');
            }
        );

        return response()->json([
            'message' => 'OTP gerado e enviado por email.',
            'otp' => $codigo,
            'expires_in_minutes' => $this->expirationMinutes,
        ]);
    }

    public function verificarOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'otp' => 'required'
        ]);

        $otp = Otp::where('email', $request->email)
                  ->where('otp', $request->otp)
                  ->first();

        if (!$otp) {
            return response()->json(['message' => 'Código OTP inválido.'], 400);
        }

        if (now()->greaterThan($otp->expires_at)) {
            $otp->delete();
            return response()->json(['message' => 'Código expirado.'], 400);
        }

        // Não removemos o OTP aqui para permitir que o AuthController::register
        // faça o consumo definitivo na criação do usuário.

        return response()->json(['message' => 'Código verificado com sucesso!'], 200);
    }

}
