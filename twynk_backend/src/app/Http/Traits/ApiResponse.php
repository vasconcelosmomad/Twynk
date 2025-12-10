<?php

namespace App\Http\Traits;

use Illuminate\Http\JsonResponse;

/**
 * Trait ApiResponse
 * 
 * Padroniza todas as respostas JSON da API com um formato consistente.
 * Fornece métodos auxiliares para respostas de sucesso e erro.
 */
trait ApiResponse
{
    /**
     * Retorna uma resposta de sucesso padrão.
     *
     * @param mixed $data Dados a serem retornados
     * @param string|null $message Mensagem opcional de sucesso
     * @param int $status Código HTTP status (default: 200)
     * @return JsonResponse
     */
    protected function success($data = null, string $message = null, int $status = 200): JsonResponse
    {
        $response = [
            'success' => true,
        ];

        if ($message !== null) {
            $response['message'] = $message;
        }

        if ($data !== null) {
            $response['data'] = $data;
        }

        return response()->json($response, $status);
    }

    /**
     * Retorna uma resposta de erro padrão.
     *
     * @param string $message Mensagem de erro
     * @param int $status Código HTTP status (default: 400)
     * @param mixed $errors Detalhes dos erros (validação, etc.)
     * @return JsonResponse
     */
    protected function error(string $message, int $status = 400, $errors = null): JsonResponse
    {
        $response = [
            'success' => false,
            'message' => $message,
        ];

        if ($errors !== null) {
            $response['errors'] = $errors;
        }

        return response()->json($response, $status);
    }

    /**
     * Retorna resposta de recurso não encontrado (404).
     *
     * @param string $message Mensagem personalizada (optional)
     * @return JsonResponse
     */
    protected function notFound(string $message = 'Recurso não encontrado'): JsonResponse
    {
        return $this->error($message, 404);
    }

    /**
     * Retorna resposta de requisição inválida (422).
     * Útil para erros de validação.
     *
     * @param mixed $errors Erros de validação
     * @param string $message Mensagem personalizada (optional)
     * @return JsonResponse
     */
    protected function validationError($errors = null, string $message = 'Dados inválidos'): JsonResponse
    {
        return $this->error($message, 422, $errors);
    }

    /**
     * Retorna resposta de não autorizado (401).
     *
     * @param string $message Mensagem personalizada (optional)
     * @return JsonResponse
     */
    protected function unauthorized(string $message = 'Não autorizado'): JsonResponse
    {
        return $this->error($message, 401);
    }

    /**
     * Retorna resposta de acesso proibido (403).
     *
     * @param string $message Mensagem personalizada (optional)
     * @return JsonResponse
     */
    protected function forbidden(string $message = 'Acesso proibido'): JsonResponse
    {
        return $this->error($message, 403);
    }

    /**
     * Retorna resposta de erro interno do servidor (500).
     *
     * @param string $message Mensagem personalizada (optional)
     * @return JsonResponse
     */
    protected function serverError(string $message = 'Erro interno do servidor'): JsonResponse
    {
        return $this->error($message, 500);
    }

    /**
     * Retorna resposta de recurso criado (201).
     *
     * @param mixed $data Dados do recurso criado
     * @param string $message Mensagem de sucesso
     * @return JsonResponse
     */
    protected function created($data = null, string $message = 'Recurso criado com sucesso'): JsonResponse
    {
        return $this->success($data, $message, 201);
    }

    /**
     * Retorna resposta sem conteúdo (204).
     *
     * @return JsonResponse
     */
    protected function noContent(): JsonResponse
    {
        return response()->json(null, 204);
    }
}
