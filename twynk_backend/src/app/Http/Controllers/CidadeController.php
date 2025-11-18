<?php

namespace App\Http\Controllers;

use App\Models\Cidade;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CidadeController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Cidade::with('provincia');

        if ($request->has('nome')) {
            $query->where('nome', 'like', '%' . $request->get('nome') . '%');
        }

        if ($request->has('provincia_id')) {
            $query->where('provincia_id', $request->get('provincia_id'));
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
            'provincia_id' => 'required|integer|exists:provincia,id',
        ]);

        $cidade = Cidade::create($validated);
        return response()->json($cidade->load('provincia'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $cidade = Cidade::with('provincia')->findOrFail($id);
        return response()->json($cidade);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, $id)
    {
        $cidade = Cidade::findOrFail($id);

        $validated = $request->validate([
            'nome' => [
                'sometimes',
                'string',
                'max:100',
            ],
            'provincia_id' => [
                'sometimes',
                'integer',
                'exists:provincia,id',
            ],
        ]);

        $cidade->update($validated);
        return response()->json($cidade->load('provincia'));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy($id)
    {
        $cidade = Cidade::findOrFail($id);
        $cidade->delete();
        return response()->json(['message' => 'Cidade removida com sucesso']);
    }
}
