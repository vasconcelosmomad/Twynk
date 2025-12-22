<?php

namespace App\Http\Controllers;

use App\Http\Traits\ApiResponse;
use App\Models\Pais;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class PaisController extends Controller
{
    use ApiResponse;
    /**
     * Listagem de países com paginação e filtros
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Pais::query();

            // Filtro por nome
            if ($request->filled('nome')) {
                $query->where('nome', 'like', '%' . $request->nome . '%');
            }

            // Filtro por status (ativo/inativo)
            if ($request->filled('status')) {
                $query->where('status', $request->status);
            } else {
                $query->where('status', 'ativo');
            }

            // Paginação (default 15)
            $perPage = $request->integer('per_page', 15);

            return $this->success(
                $query->orderBy('nome')->paginate($perPage),
                'Países listados com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao listar países');
        }
    }

    /**
     * Criar um novo país
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'nome' => 'required|string|max:100|unique:pais,nome',
                'status' => 'nullable|in:ativo,inativo',
            ]);

            $pais = Pais::create($validated);

            return $this->created(
                $pais,
                'País criado com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao criar país');
        }
    }

    /**
     * Exibir país específico usando Route Model Binding
     * 
     * @param Pais $pais
     * @return JsonResponse
     */
    public function show(Pais $pais): JsonResponse
    {
        try {
            $pais->load('provincias');

            return $this->success(
                $pais,
                'País encontrado com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao buscar país');
        }
    }

    /**
     * Atualizar país usando Route Model Binding
     * 
     * @param Request $request
     * @param Pais $pais
     * @return JsonResponse
     */
    public function update(Request $request, Pais $pais): JsonResponse
    {
        try {
            $validated = $request->validate([
                'nome' => [
                    'sometimes',
                    'string',
                    'max:100',
                    Rule::unique('pais', 'nome')->ignore($pais->id),
                ],
                'status' => [
                    'sometimes',
                    'in:ativo,inativo',
                ],
            ]);

            $pais->update($validated);

            return $this->success(
                $pais,
                'País atualizado com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao atualizar país');
        }
    }

    /**
     * Remover país usando Route Model Binding
     * 
     * @param Pais $pais
     * @return JsonResponse
     */
    public function destroy(Pais $pais): JsonResponse
    {
        try {
            $pais->delete();

            return $this->success(
                null,
                'País removido com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao remover país');
        }
    }
}
