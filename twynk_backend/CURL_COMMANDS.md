# Comandos CURL para Testar Autenticação JWT

## Pré-requisitos
1. Servidor rodando: `docker compose up -d`
2. JWT configurado: `docker compose exec twynk php artisan jwt:secret`
3. Migrations rodadas: `docker compose exec twynk php artisan migrate`

## Base URL
```
http://localhost:8080/api
```

## 1. Registrar Novo Usuário

```bash
curl -X POST http://localhost:8080/api/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "nome": "João Silva",
    "genero": "masculino",
    "interesse": "feminino",
    "data_nascimento": "1990-01-01",
    "email": "joao@teste.com",
    "password": "senha123"
  }'
```

**Resposta esperada:**
```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "nome": "João Silva",
    "email": "joao@teste.com",
    ...
  }
}
```

## 2. Login

```bash
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "joao@teste.com",
    "password": "senha123"
  }'
```

**Resposta esperada:**
```json
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "nome": "João Silva",
    "email": "joao@teste.com",
    ...
  }
}
```

## 3. Obter Perfil (Protegido)

Substitua `SEU_TOKEN_AQUI` pelo token recebido no login/register:

```bash
curl -X GET http://localhost:8080/api/profile \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Accept: application/json"
```

**Resposta esperada:**
```json
{
  "id": 1,
  "nome": "João Silva",
  "email": "joao@teste.com",
  "genero": "masculino",
  ...
}
```

## 4. Logout (Protegido)

```bash
curl -X POST http://localhost:8080/api/logout \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Accept: application/json"
```

**Resposta esperada:**
```json
{
  "message": "Logout efetuado com sucesso"
}
```

## 5. Script Automatizado

Execute o script de teste:
```bash
./test_curl.sh
```

## Exemplo Completo (Copiar e Colar)

```bash
# 1. Registrar
TOKEN=$(curl -s -X POST http://localhost:8080/api/register \
  -H "Content-Type: application/json" \
  -d '{"nome":"João","genero":"masculino","interesse":"feminino","data_nascimento":"1990-01-01","email":"joao@teste.com","password":"senha123"}' \
  | grep -o '"token":"[^"]*' | cut -d'"' -f4)

echo "Token: $TOKEN"

# 2. Ver perfil
curl -X GET http://localhost:8080/api/profile \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json"

# 3. Logout
curl -X POST http://localhost:8080/api/logout \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json"
```

