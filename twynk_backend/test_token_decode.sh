#!/bin/bash

# Script para fazer login e decodificar o token JWT
BASE_URL="http://localhost:8080/api"

echo "=========================================="
echo "Login e Decodificação de Token JWT"
echo "=========================================="
echo ""

# Fazer login
echo "1. Fazendo login..."
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

# Extrair token
TOKEN=$(echo "$LOGIN_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token', ''))" 2>/dev/null)

if [ -z "$TOKEN" ]; then
    # Tentar método alternativo
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
fi

if [ -z "$TOKEN" ]; then
    echo "❌ Erro: Não foi possível obter token."
    echo ""
    echo "Tentando registrar usuário primeiro..."
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
    
    TOKEN=$(echo "$REGISTER_RESPONSE" | python3 -c "import sys, json; print(json.load(sys.stdin).get('token', ''))" 2>/dev/null)
    
    if [ -z "$TOKEN" ]; then
        TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
    fi
fi

if [ -z "$TOKEN" ]; then
    echo "❌ Erro: Não foi possível obter token após registro."
    exit 1
fi

echo "=========================================="
echo "✅ TOKEN OBTIDO"
echo "=========================================="
echo ""
echo "Token (primeiros 50 caracteres): ${TOKEN:0:50}..."
echo ""

# Decodificar token JWT
echo "=========================================="
echo "📋 DECODIFICANDO TOKEN JWT"
echo "=========================================="
echo ""

# JWT tem 3 partes: header.payload.signature
# Extrair payload (segunda parte)
PAYLOAD=$(echo "$TOKEN" | cut -d'.' -f2)

if [ -z "$PAYLOAD" ]; then
    echo "❌ Erro: Token inválido (formato incorreto)"
    exit 1
fi

# Decodificar payload (base64url)
# Adicionar padding se necessário
PADDING_LENGTH=$((4 - ${#PAYLOAD} % 4))
if [ $PADDING_LENGTH -ne 4 ]; then
    PAYLOAD="${PAYLOAD}$(printf '%*s' $PADDING_LENGTH | tr ' ' '=')"
fi

# Converter base64url para base64 (substituir - por + e _ por /)
PAYLOAD_B64=$(echo "$PAYLOAD" | tr '_-' '/+')

# Decodificar usando Python (mais confiável)
echo "📦 PAYLOAD (Claims do Token):"
echo ""

DECODED=$(python3 <<EOF
import base64
import json
import sys

payload = "$PAYLOAD_B64"

try:
    # Adicionar padding se necessário
    missing_padding = len(payload) % 4
    if missing_padding:
        payload += '=' * (4 - missing_padding)
    
    # Decodificar base64
    decoded_bytes = base64.urlsafe_b64decode(payload)
    decoded_str = decoded_bytes.decode('utf-8')
    
    # Parse JSON e formatar
    claims = json.loads(decoded_str)
    print(json.dumps(claims, indent=2, ensure_ascii=False))
except Exception as e:
    print(f"Erro ao decodificar: {e}", file=sys.stderr)
    sys.exit(1)
EOF
)

if [ $? -eq 0 ]; then
    echo "$DECODED"
    echo ""
    
    # Extrair informações específicas
    echo "=========================================="
    echo "📊 INFORMAÇÕES EXTRAÍDAS"
    echo "=========================================="
    echo ""
    
    # Usar Python para extrair campos específicos
    python3 <<EOF
import json
import sys
from datetime import datetime

claims_json = '''$DECODED'''
claims = json.loads(claims_json)

print("👤 Dados do Usuário:")
print(f"   ID (sub): {claims.get('sub', 'N/A')}")
print(f"   Nome: {claims.get('name', 'N/A')}")
print(f"   Email: {claims.get('email', 'N/A')}")
print(f"   Role: {claims.get('role', 'N/A')}")
print(f"   Verificado: {claims.get('is_verified', False)}")
print(f"   Foto: {claims.get('profile_photo', 'N/A')}")
print()

print("💳 Plano:")
print(f"   ID do Plano: {claims.get('plan', 'N/A')}")
if claims.get('plan_exp'):
    exp_date = datetime.fromtimestamp(claims['plan_exp'])
    print(f"   Expira em: {exp_date.strftime('%Y-%m-%d %H:%M:%S')} ({claims['plan_exp']})")
else:
    print(f"   Expiração: N/A")
print()

print("💰 Créditos:")
print(f"   Saldo: {claims.get('credits', 0.0)}")
print()

print("⏰ Informações do Token:")
print(f"   Emitido em (iat): {datetime.fromtimestamp(claims.get('iat', 0)).strftime('%Y-%m-%d %H:%M:%S') if claims.get('iat') else 'N/A'}")
print(f"   Expira em (exp): {datetime.fromtimestamp(claims.get('exp', 0)).strftime('%Y-%m-%d %H:%M:%S') if claims.get('exp') else 'N/A'}")
print(f"   Não antes de (nbf): {datetime.fromtimestamp(claims.get('nbf', 0)).strftime('%Y-%m-%d %H:%M:%S') if claims.get('nbf') else 'N/A'}")
print(f"   JWT ID (jti): {claims.get('jti', 'N/A')}")
print(f"   Issuer (iss): {claims.get('iss', 'N/A')}")
EOF

else
    echo "❌ Erro ao decodificar token"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ Decodificação concluída!"
echo "=========================================="

