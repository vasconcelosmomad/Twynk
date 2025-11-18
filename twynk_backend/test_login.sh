#!/bin/bash

# Script para testar login JWT e obter token
BASE_URL="http://localhost:8080/api"

echo "=========================================="
echo "Teste de Login JWT - Obter Token"
echo "=========================================="
echo ""

# 1. Registrar usuário (se não existir)
echo "1. Registrando usuário de teste..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/register" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "nome": "João Silva",
    "genero": "masculino",
    "interesse": "feminino",
    "data_nascimento": "1990-01-01",
    "email": "joao@teste.com",
    "password": "senha123"
  }')

echo "Resposta do registro:"
echo "$REGISTER_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$REGISTER_RESPONSE"
echo ""

# Extrair token do registro
TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "⚠️  Token não encontrado no registro. Tentando fazer login..."
    echo ""
    
    # 2. Fazer login
    echo "2. Fazendo login..."
    LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -d '{
        "email": "joao@teste.com",
        "password": "senha123"
      }')
    
    echo "Resposta do login:"
    echo "$LOGIN_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$LOGIN_RESPONSE"
    echo ""
    
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
fi

if [ -z "$TOKEN" ]; then
    echo "❌ Erro: Não foi possível obter token."
    exit 1
fi

echo "=========================================="
echo "✅ TOKEN OBTIDO COM SUCESSO!"
echo "=========================================="
echo ""
echo "Token: $TOKEN"
echo ""
echo "=========================================="
echo "Comandos para usar o token:"
echo "=========================================="
echo ""
echo "# Ver perfil:"
echo "curl -X GET $BASE_URL/profile \\"
echo "  -H 'Authorization: Bearer $TOKEN' \\"
echo "  -H 'Accept: application/json'"
echo ""
echo "# Logout:"
echo "curl -X POST $BASE_URL/logout \\"
echo "  -H 'Authorization: Bearer $TOKEN' \\"
echo "  -H 'Accept: application/json'"
echo ""

# 3. Testar rota protegida
echo "3. Testando rota protegida (GET /api/profile)..."
PROFILE_RESPONSE=$(curl -s -X GET "$BASE_URL/profile" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta do profile:"
echo "$PROFILE_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$PROFILE_RESPONSE"
echo ""

echo "=========================================="
echo "✅ Teste concluído!"
echo "=========================================="
