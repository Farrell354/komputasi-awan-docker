FROM php:8.2-fpm

# Install dependencies sistem
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Set working directory di container
WORKDIR /var/www

# Copy semua file project ke container
COPY . .

# Install composer dari image composer resmi
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Install dependencies Laravel
RUN composer install --no-interaction --optimize-autoloader

# Set permission folder storage
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]
