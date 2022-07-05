#################################
# Setup php-fpm (Development)
#################################
FROM php:5.6.4-fpm AS admin-ui-php-dev
WORKDIR /code

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

#################################
# Setup php-fpm (Production)
#################################
FROM admin-ui-php-dev AS admin-ui-php
WORKDIR /code

# Copy source code
COPY src .

# Install dependencies
#RUN composer install --prefer-dist --no-progress --no-suggest --optimize-autoloader; \
#    composer clear-cache

#################################
# Setup nginx
#################################
FROM nginx:1.20.1-alpine AS admin-ui-nginx
WORKDIR /code

COPY docker/nginx/site.conf /etc/nginx/sites-available/default.conf
COPY --from=admin-ui-php /code/public public/

EXPOSE 80