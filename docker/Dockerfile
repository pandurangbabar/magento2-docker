# syntax=docker/dockerfile:1
FROM php:8.4-apache

# Install PHP extension helper
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# System dependencies (single layer, cleaned)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libssl-dev \
    libzip-dev \
    libxslt1-dev \
    gnupg \
    redis-tools \
    git \
    vim \
    wget \
    curl \
    lynx \
    psmisc \
    unzip \
    tar \
    cron \
    bash-completion \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Composer (pinned version)
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=2.8.8 \
    && rm composer-setup.php

# PHP extensions required by Magento
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

# Apache modules
RUN a2enmod rewrite expires headers ssl

# PHP & Apache configs
COPY .docker/php/php.ini /usr/local/etc/php/php.ini
COPY .docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY .docker/apache/local.m2docker.conf /etc/apache2/sites-available/local.m2docker.conf

# Magento root
WORKDIR /var/www/html

EXPOSE 80 443
