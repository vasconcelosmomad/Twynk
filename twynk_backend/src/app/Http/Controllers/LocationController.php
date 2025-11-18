<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Provincia;
use App\Models\Cidade;

class LocationController extends Controller
{
    public function getProvincias($pais_id)
    {
        $provincias = Provincia::where('pais_id', $pais_id)->get();
        return response()->json($provincias);
    }

    public function getCidades($provincia_id)
    {
        $cidades = Cidade::where('provincia_id', $provincia_id)->get();
        return response()->json($cidades);
    }
}
