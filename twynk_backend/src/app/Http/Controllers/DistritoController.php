<?php

namespace App\Http\Controllers;

use App\Http\Traits\ApiResponse;
use App\Models\Distrito;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DistritoController extends Controller
{
    use ApiResponse;

    public function index(Request $request): JsonResponse
    {
        try {
            $query = Distrito::with('provincia');

            if ($request->filled('nome')) {
                $query->where('nome', 'like', '%' . $request->nome . '%');
            }

            if ($request->filled('provincia_id')) {
                $query->where('provincia_id', $request->provincia_id);
            }

            $perPage = $request->integer('per_page', 15);

            return $this->success(
                $query->orderBy('nome')->paginate($perPage),
                'Distritos listados com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao listar distritos');
        }
    }

    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'nome'         => 'required|string|max:100',
                'provincia_id' => 'required|integer|exists:provincia,id',
            ]);

            $distrito = Distrito::create($validated);

            return $this->created(
                $distrito->load('provincia'),
                'Distrito criado com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao criar distrito');
        }
    }

    public function show(Distrito $distrito): JsonResponse
    {
        try {
            $distrito->load('provincia');

            return $this->success(
                $distrito,
                'Distrito encontrado com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao buscar distrito');
        }
    }

    public function update(Request $request, Distrito $distrito): JsonResponse
    {
        try {
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

            $distrito->update($validated);

            return $this->success(
                $distrito->load('provincia'),
                'Distrito atualizado com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao atualizar distrito');
        }
    }

    public function destroy(Distrito $distrito): JsonResponse
    {
        try {
            $distrito->delete();

            return $this->success(
                null,
                'Distrito removido com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao remover distrito');
        }
    }
}
