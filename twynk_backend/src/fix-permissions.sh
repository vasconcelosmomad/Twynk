#!/bin/bash
set -e

# Definir usuário e grupo padrão (www-data) ou usar UID/GID do host se fornecido
USER_ID=${LOCAL_UID:-33}   # 33 é o UID padrão do www-data no Debian/Alpine
GROUP_ID=${LOCAL_GID:-33}  # 33 é o GID padrão do www-data

# Criar usuário www-data se não existir
if ! id -u www-data >/dev/null 2>&1; then
    useradd -u $USER_ID -o -m www-data
fi

# Atualizar UID/GID de www-data se necessário
usermod -u $USER_ID www-data || true
groupmod -g $GROUP_ID www-data || true

# Ajustar propriedade e permissões das pastas críticas do Laravel
chown -R www-data:www-data /var/www/twynk/storage /var/www/twynk/bootstrap/cache
chmod -R 775 /var/www/twynk/storage /var/www/twynk/bootstrap/cache

# Opcional: ajustar permissões de outros diretórios se necessário
# chmod -R 775 /var/www/twynk/public

# Executar o PHP-FPM
exec php-fpm

