# syntax=docker/dockerfile:1
FROM php:8.4-fpm

# PHP extension installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# System dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libssl-dev \
    libzip-dev \
    libxslt1-dev \
    git \
    unzip \
    curl \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=2.9.5 \
    && rm composer-setup.php

# PHP extensions (Magento required)
RUN docker-php-ext-configure gd \
    && install-php-extensions \
        bcmath \
        gd \
        intl \
        pdo_mysql \
        soap \
        opcache \
        sockets \
        xsl \
        zip \
        ftp

# PHP config
COPY .docker/php/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html