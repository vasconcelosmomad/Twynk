<?php

namespace App\Http\Controllers;

use App\Models\Pais;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class PaisController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Pais::query();

        if ($request->has('nome')) {
            $query->where('nome', 'like', '%' . $request->get('nome') . '%');
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
            'nome' => 'required|string|max:100|unique:pais,nome',
        ]);

        $pais = Pais::create($validated);
        return response()->json($pais, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $pais = Pais::with('provincias')->findOrFail($id);
        return response()->json($pais);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $pais = Pais::findOrFail($id);

        $validated = $request->validate([
            'nome' => [
                'sometimes',
                'string',
                'max:100',
                Rule::unique('pais', 'nome')->ignore($pais->id),
            ],
        ]);

        $pais->update($validated);
        return response()->json($pais);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $pais = Pais::findOrFail($id);
        $pais->delete();
        return response()->json(['message' => 'País removido com sucesso']);
    }
}
