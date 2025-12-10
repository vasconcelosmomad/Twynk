<?php

namespace App\Http\Controllers;

use App\Http\Traits\ApiResponse;
use App\Models\Cidade;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CidadeController extends Controller
{
    use ApiResponse;
    /**
     * Listagem de cidades com filtros e paginação
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = Cidade::with('provincia');

            // Filtro por nome
            if ($request->filled('nome')) {
                $query->where('nome', 'like', '%' . $request->nome . '%');
            }

            // Filtro por província
            if ($request->filled('provincia_id')) {
                $query->where('provincia_id', $request->provincia_id);
            }

            $perPage = $request->integer('per_page', 15);

            return $this->success(
                $query->orderBy('nome')->paginate($perPage),
                'Cidades listadas com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao listar cidades');
        }
    }

    /**
     * Criar nova cidade
     * 
     * @param Request $request
     * @return JsonResponse
     */
    public function store(Request $request): JsonResponse
    {
        try {
            $validated = $request->validate([
                'nome'          => 'required|string|max:100',
                'provincia_id'  => 'required|integer|exists:provincia,id',
            ]);

            $cidade = Cidade::create($validated);

            return $this->created(
                $cidade->load('provincia'),
                'Cidade criada com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao criar cidade');
        }
    }

    /**
     * Exibir uma cidade específica usando Route Model Binding
     * 
     * @param Cidade $cidade
     * @return JsonResponse
     */
    public function show(Cidade $cidade): JsonResponse
    {
        try {
            $cidade->load('provincia');

            return $this->success(
                $cidade,
                'Cidade encontrada com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao buscar cidade');
        }
    }

    /**
     * Atualizar cidade usando Route Model Binding
     * 
     * @param Request $request
     * @param Cidade $cidade
     * @return JsonResponse
     */
    public function update(Request $request, Cidade $cidade): JsonResponse
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

            $cidade->update($validated);

            return $this->success(
                $cidade->load('provincia'),
                'Cidade atualizada com sucesso'
            );
        } catch (\Illuminate\Validation\ValidationException $e) {
            return $this->validationError($e->errors());
        } catch (\Exception $e) {
            return $this->serverError('Erro ao atualizar cidade');
        }
    }

    /**
     * Remover cidade usando Route Model Binding
     * 
     * @param Cidade $cidade
     * @return JsonResponse
     */
    public function destroy(Cidade $cidade): JsonResponse
    {
        try {
            $cidade->delete();

            return $this->success(
                null,
                'Cidade removida com sucesso'
            );
        } catch (\Exception $e) {
            return $this->serverError('Erro ao remover cidade');
        }
    }
}
