<?php

namespace App\Http\Controllers;

use App\Models\Provincia;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ProvinciaController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Provincia::with('pais');

        if ($request->has('nome')) {
            $query->where('nome', 'like', '%' . $request->get('nome') . '%');
        }

        if ($request->has('pais_id')) {
            $query->where('pais_id', $request->get('pais_id'));
        }

        $perPage = (int) $request->get('per_page', 15);
        return response()->json($query->orderBy('nome')->paginate($perPage));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nome' => 'required|string|max:100',
            'pais_id' => 'required|integer|exists:pais,id',
        ]);

        $provincia = Provincia::create($validated);
        return response()->json($provincia->load('pais'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $provincia = Provincia::with(['pais', 'cidades'])->findOrFail($id);
        return response()->json($provincia);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $provincia = Provincia::findOrFail($id);

        $validated = $request->validate([
            'nome' => [
                'sometimes',
                'string',
                'max:100',
            ],
            'pais_id' => [
                'sometimes',
                'integer',
                'exists:pais,id',
            ],
        ]);

        $provincia->update($validated);
        return response()->json($provincia->load('pais'));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $provincia = Provincia::findOrFail($id);
        $provincia->delete();
        return response()->json(['message' => 'Província removida com sucesso']);
    }
}
