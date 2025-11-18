<?php

namespace App\Http\Controllers;

use App\Models\Otp;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Carbon\Carbon;

class OtpController extends Controller
{
    public function gerarOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $codigo = rand(100000, 999999);

        Otp::where('email', $request->email)->delete();

        Otp::create([
            'email' => $request->email,
            'otp' => $codigo,
            'expires_at' => Carbon::now()->addMinutes(5),
        ]);

        return response()->json([
            'message' => 'OTP gerado com sucesso.',
            'otp' => $codigo
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

        $otp->delete();

        return response()->json(['message' => 'Código verificado com sucesso!'], 200);
    }

}
