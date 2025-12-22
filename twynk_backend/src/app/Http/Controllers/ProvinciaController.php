<?php

namespace App\Http\Controllers;

use App\Http\Traits\ApiResponse;
use App\Models\Provincia;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class ProvinciaController extends Controller
{
    use ApiResponse;
    /**
     * Listagem de províncias com filtros e paginação
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Provincia::with('pais');

            // Filtro por nome
            if ($request->filled('nome')) {
                $query->where('nome', 'like', '%' . $request->nome . '%');
            }

            // Filtro por país
            if ($request->filled('pais_id')) {
                $query->where('pais_id', $request->pais_id);
            }

            $perPage = $request->integer('per_page', 15);

            return $this->success(
                $query->orderBy('nome')->paginate($perPage),
                'Províncias listadas com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao listar províncias');
        }
    }

    /**
     * Criar nova província
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'nome'     => 'required|string|max:100',
                'pais_id'  => 'required|integer|exists:pais,id',
            ]);

            $provincia = Provincia::create($validated);

            return $this->created(
                $provincia->load('pais'),
                'Província criada com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao criar província');
        }
    }

    /**
     * Exibir província específica usando Route Model Binding
     * 
     * @param Provincia $provincia
     * @return JsonResponse
     */
    public function show(Provincia $provincia): JsonResponse
    {
        try {
            $provincia->load(['pais', 'distrito']);

            return $this->success(
                $provincia,
                'Província encontrada com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao buscar província');
        }
    }

    /**
     * Atualizar província usando Route Model Binding
     * 
     * @param Request $request
     * @param Provincia $provincia
     * @return JsonResponse
     */
    public function update(Request $request, Provincia $provincia): JsonResponse
    {
        try {
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

            return $this->success(
                $provincia->load('pais'),
                'Província atualizada com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao atualizar província');
        }
    }

    /**
     * Remover província usando Route Model Binding
     * 
     * @param Provincia $provincia
     * @return JsonResponse
     */
    public function destroy(Provincia $provincia): JsonResponse
    {
        try {
            $provincia->delete();

            return $this->success(
                null,
                'Província removida com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao remover província');
        }
    }
}
