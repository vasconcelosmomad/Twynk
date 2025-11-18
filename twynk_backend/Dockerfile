FROM php:8.2-fpm

WORKDIR /var/www/twynk

# Instalar dependências do sistema e extensões PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Nota: Em desenvolvimento, o código é montado via volume (./src:/var/www/twynk)
# As dependências do Composer serão instaladas no volume ou via volume nomeado
# Este Dockerfile prepara o ambiente PHP-FPM com todas as extensões necessárias

# Criar diretórios necessários e ajustar permissões
RUN mkdir -p storage bootstrap/cache \
    && chown -R www-data:www-data /var/www/twynk \
    && chmod -R 775 storage bootstrap/cache

# Manter como root para permitir ajustes de permissão via volumes
# O PHP-FPM roda como www-data internamente

EXPOSE 9000
CMD ["php-fpm"]
