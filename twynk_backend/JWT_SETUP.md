# Configuração JWT - Passos para Instalação

## 1. Instalar os pacotes necessários

Execute os seguintes comandos dentro do container Docker:

```bash
docker compose exec twynk composer require tymon/jwt-auth
docker compose exec twynk composer require laravel/socialite
```

## 2. Publicar configuração JWT

```bash
docker compose exec twynk php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
```

## 3. Gerar JWT Secret

```bash
docker compose exec twynk php artisan jwt:secret
```

Isso irá gerar o `JWT_SECRET` no arquivo `.env`.

## 4. Configurar Socialite (Google OAuth)

Adicione no arquivo `.env`:

```env
GOOGLE_CLIENT_ID=seu_client_id_aqui
GOOGLE_CLIENT_SECRET=seu_client_secret_aqui
GOOGLE_REDIRECT_URI=http://localhost:8080/api/login/google/callback
```

## 5. Arquivos já criados

✅ `routes/api.php` - Rotas de autenticação
✅ `app/Http/Controllers/AuthController.php` - Controller de autenticação
✅ `app/Models/User.php` - Model atualizado com JWTSubject
✅ `config/auth.php` - Guard 'api' configurado
✅ `bootstrap/app.php` - Rotas API habilitadas

## 6. Testar as rotas

### Registrar usuário
```bash
POST /api/register
{
  "nome": "João Silva",
  "genero": "masculino",
  "interesse": "feminino",
  "data_nascimento": "1990-01-01",
  "email": "joao@example.com",
  "password": "senha123"
}
```

### Login
```bash
POST /api/login
{
  "email": "joao@example.com",
  "password": "senha123"
}
```

### Login Google
```bash
POST /api/login/google
{
  "idToken": "token_do_google"
}
```

### Perfil (protegido)
```bash
GET /api/profile
Headers: Authorization: Bearer {token}
```

### Logout
```bash
POST /api/logout
Headers: Authorization: Bearer {token}
```

## Notas

- O campo `password` é nullable para permitir login via Google
- O campo `google_id` é usado para identificar usuários que se registraram via Google
- O token JWT deve ser enviado no header `Authorization: Bearer {token}`

