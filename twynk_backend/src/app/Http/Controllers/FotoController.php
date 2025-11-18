<?php

namespace App\Http\Controllers;

use App\Models\Foto;
use Illuminate\Http\Request;

class FotoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Foto::with('usuario');

        if ($request->has('usuario_id')) {
            $query->where('usuario_id', $request->usuario_id);
        }

        $fotos = $query->orderBy('data_upload', 'desc')
            ->paginate($request->get('per_page', 20));

        return response()->json($fotos);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'usuario_id' => 'required|exists:users,id',
            'url_foto' => 'required|string|max:255',
            'descricao' => 'nullable|string|max:255',
        ]);

        $foto = Foto::create($validated);

        return response()->json($foto, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $foto = Foto::with('usuario')->findOrFail($id);

        return response()->json($foto);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $foto = Foto::findOrFail($id);

        $validated = $request->validate([
            'url_foto' => 'sometimes|string|max:255',
            'descricao' => 'nullable|string|max:255',
        ]);

        $foto->update($validated);

        return response()->json($foto);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $foto = Foto::findOrFail($id);
        $foto->delete();

        return response()->json(['message' => 'Foto deletada com sucesso'], 200);
    }
}

