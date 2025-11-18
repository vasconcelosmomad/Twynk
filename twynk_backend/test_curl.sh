#!/bin/bash

# Script para testar autenticação JWT com curl
# URL base da API
BASE_URL="http://localhost:8080/api"

echo "=========================================="
echo "Teste de Autenticação JWT - CURL"
echo "=========================================="
echo ""

# 1. Registrar um novo usuário
echo "1. Registrando novo usuário..."
echo "curl -X POST $BASE_URL/register \\"
echo "  -H 'Content-Type: application/json' \\"
echo "  -H 'Accept: application/json' \\"
echo "  -d '{\"nome\":\"João Silva\",\"genero\":\"masculino\",\"interesse\":\"feminino\",\"data_nascimento\":\"1990-01-01\",\"email\":\"joao@teste.com\",\"password\":\"senha123\"}'"
echo ""

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

echo "Resposta:"
echo "$REGISTER_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$REGISTER_RESPONSE"
echo ""

# Extrair token do registro
TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "⚠️  Token não encontrado no registro. Tentando fazer login..."
    echo ""
    
    # 2. Fazer login
    echo "2. Fazendo login..."
    echo "curl -X POST $BASE_URL/login \\"
    echo "  -H 'Content-Type: application/json' \\"
    echo "  -H 'Accept: application/json' \\"
    echo "  -d '{\"email\":\"joao@teste.com\",\"password\":\"senha123\"}'"
    echo ""
    
    LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -d '{
        "email": "joao@teste.com",
        "password": "senha123"
      }')
    
    echo "Resposta:"
    echo "$LOGIN_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$LOGIN_RESPONSE"
    echo ""
    
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
fi

if [ -z "$TOKEN" ]; then
    echo "❌ Erro: Não foi possível obter token."
    echo "Verifique se:"
    echo "  - O servidor está rodando (docker compose up)"
    echo "  - JWT está configurado (php artisan jwt:secret)"
    echo "  - As rotas API estão acessíveis"
    exit 1
fi

echo "✅ Token obtido: ${TOKEN:0:50}..."
echo ""

# 3. Testar rota protegida - Profile
echo "3. Testando rota protegida (GET /api/profile)..."
echo "curl -X GET $BASE_URL/profile \\"
echo "  -H 'Authorization: Bearer $TOKEN' \\"
echo "  -H 'Accept: application/json'"
echo ""

PROFILE_RESPONSE=$(curl -s -X GET "$BASE_URL/profile" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta:"
echo "$PROFILE_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$PROFILE_RESPONSE"
echo ""

# 4. Testar logout
echo "4. Testando logout..."
echo "curl -X POST $BASE_URL/logout \\"
echo "  -H 'Authorization: Bearer $TOKEN' \\"
echo "  -H 'Accept: application/json'"
echo ""

LOGOUT_RESPONSE=$(curl -s -X POST "$BASE_URL/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "Resposta:"
echo "$LOGOUT_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$LOGOUT_RESPONSE"
echo ""

echo "=========================================="
echo "✅ Testes concluídos!"
echo "=========================================="
echo ""
echo "Comandos CURL para uso manual:"
echo ""
echo "# Registrar:"
echo "curl -X POST $BASE_URL/register -H 'Content-Type: application/json' -d '{\"nome\":\"João\",\"genero\":\"masculino\",\"data_nascimento\":\"1990-01-01\",\"email\":\"joao@teste.com\",\"password\":\"senha123\"}'"
echo ""
echo "# Login:"
echo "curl -X POST $BASE_URL/login -H 'Content-Type: application/json' -d '{\"email\":\"joao@teste.com\",\"password\":\"senha123\"}'"
echo ""
echo "# Profile (substitua TOKEN pelo token recebido):"
echo "curl -X GET $BASE_URL/profile -H 'Authorization: Bearer TOKEN'"
echo ""
echo "# Logout:"
echo "curl -X POST $BASE_URL/logout -H 'Authorization: Bearer TOKEN'"

