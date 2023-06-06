# syntax=docker/dockerfile:1
FROM php:8.1.18-apache 

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# Install System Dependencies
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	software-properties-common \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libfreetype6-dev \
	libicu-dev \
  libssl-dev \
  libzip-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libedit-dev \
	libedit2 \
	libxslt1-dev \
	apt-utils \
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
	&& apt-get clean

#PHP configuration for magento 2
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/;
RUN	install-php-extensions bcmath gd intl pdo_mysql soap opcache sockets xsl zip

#Apache2 configuration for magento 2
RUN	apt-get update
RUN	a2enmod rewrite
RUN	a2enmod expires
RUN	a2enmod headers
RUN	a2enmod ssl

ADD .docker/apache/local.m2docker.conf /etc/apache2/sites-available/local.m2docker.conf
RUN ln -s /etc/apache2/sites-available/local.m2docker.conf /etc/apache2/sites-enabled/local.m2docker.conf

ADD .docker/php/php.ini /usr/local/etc/php/php.ini

RUN service apache2 restart

