FROM php:8.3-fpm-alpine

# تثبيت الحزم اللازمة
RUN apk add --no-cache \
    git curl unzip libpng libpng-dev oniguruma-dev libxml2-dev zip bash \
    && docker-php-ext-install pdo_mysql mbstring bcmath gd

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Workdir
WORKDIR /var/www/project-gen-api

# نسخ المشروع
COPY . .

# تثبيت PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# نسخ .env example إلا ما كاينش
RUN [ ! -f .env ] && cp .env.example .env || true

# توليد app key إلا ما كاينش
RUN php artisan key:generate --force

# صلاحيات
RUN chown -R www-data:www-data /var/www/project-gen-api \
    && chmod -R 755 /var/www/project-gen-api

EXPOSE 9000

CMD ["php-fpm"]
