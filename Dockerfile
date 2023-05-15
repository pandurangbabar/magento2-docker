# syntax=docker/dockerfile:1
FROM php:8.1.18-apache 

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
RUN docker-php-ext-configure \
  	gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
	docker-php-ext-install \
  	bcmath \
  	gd \
  	intl \
  	pdo_mysql \	
  	soap \
  	opcache \
  	sockets \
  	xsl \
  	zip \
  	mbstring \

#Apache2 configuration for magento 2
RUN	apt-get update -y
RUN	a2enmod rewrite
RUN	a2enmod expires
RUN	a2enmod headers
RUN	a2enmod ssl
ADD .docker/apache/local.m2docker.conf /etc/apache2/sites-available/local.m2docker.conf
RUN ln -s /etc/apache2/sites-available/local.m2docker.conf /etc/apache2/sites-enabled/local.m2docker.conf
RUN service apache2 restart

