# Acesso ao phpMyAdmin

## URL de Acesso
```
http://localhost:8081
```

## Credenciais de Login

### Opção 1: Usuário Root (Recomendado)
- **Servidor:** `db` (ou deixe em branco)
- **Usuário:** `root`
- **Senha:** `root`

### Opção 2: Usuário Laravel
- **Servidor:** `db` (ou deixe em branco)
- **Usuário:** `laravel`
- **Senha:** `laravel`

## Informações do Banco de Dados

- **Nome do Banco:** `twynk_db`
- **Host MySQL:** `db` (dentro da rede Docker) ou `localhost:3307` (do host)
- **Porta MySQL:** `3306` (dentro do container) ou `3307` (do host)

## Passos para Acessar

1. Certifique-se de que os containers estão rodando:
   ```bash
   docker compose ps
   ```

2. Abra o navegador e acesse:
   ```
   http://localhost:8081
   ```

3. Na tela de login do phpMyAdmin:
   - **Servidor:** Deixe `db` ou deixe em branco
   - **Usuário:** `root`
   - **Senha:** `root`
   - Clique em **"Entrar"** ou **"Go"**

## Acesso Direto ao MySQL (via linha de comando)

Se preferir usar o MySQL diretamente:

```bash
# Acessar o container MySQL
docker compose exec db mysql -uroot -proot twynk_db

# Ou do host
mysql -h 127.0.0.1 -P 3307 -uroot -proot twynk_db
```

## Verificar se phpMyAdmin está rodando

```bash
docker compose ps | grep phpmyadmin
```

Se não estiver rodando:
```bash
docker compose up -d phpmyadmin
```

