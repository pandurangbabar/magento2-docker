# syntax=docker/dockerfile:1
FROM php:8.4-apache 

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

# Install System Dependencies
RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	&& apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
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
	&& apt-get clean

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer --version=2.8.8
RUN php -r "unlink('composer-setup.php');"

#PHP configuration for magento 2
RUN docker-php-ext-configure gd ;
RUN	install-php-extensions bcmath gd intl pdo_mysql soap opcache sockets xsl zip ftp

#Apache2 configuration for magento 2
RUN	apt-get update
RUN	a2enmod rewrite
RUN	a2enmod expires
RUN	a2enmod headers
RUN	a2enmod ssl

ADD .docker/php/php.ini /usr/local/etc/php/php.ini

COPY .docker/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY .docker/apache/local.m2docker.conf /etc/apache2/sites-available/local.m2docker.conf

RUN service apache2 restart

VOLUME /var/www/html
WORKDIR /var/www/html

EXPOSE 80
EXPOSE 443

