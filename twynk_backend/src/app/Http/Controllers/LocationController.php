<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Provincia;
use App\Models\Distrito;
use App\Models\Pais;

class LocationController extends Controller
{
    public function getProvincias($pais_id)
    {
        $pais = Pais::find($pais_id);

        if (!$pais || $pais->status !== 'ativo') {
            return response()->json([
                'success' => false,
                'message' => 'País não encontrado ou inativo',
            ], 404);
        }

        $provincias = Provincia::where('pais_id', $pais_id)->get();
        return response()->json($provincias);
    }

    // Mantido por compatibilidade, mas agora retorna distritos
    public function getCidades($provincia_id)
    {
        $distritos = Distrito::where('provincia_id', $provincia_id)->get();
        return response()->json($distritos);
    }

    // Nova rota explícita para distritos
    public function getDistritos($provincia_id)
    {
        $distritos = Distrito::where('provincia_id', $provincia_id)->get();
        return response()->json($distritos);
    }
}
