# syntax=docker/dockerfile:1
FROM php:8.1.18-apache 

#Apache2 configuration for magento 2
RUN	apt-get update -y
RUN	a2enmod rewrite
RUN	a2enmod expires
RUN	a2enmod headers
RUN	a2enmod ssl
ADD .docker/apache/local.m2docker.conf /etc/apache2/sites-available/local.m2docker.conf
RUN ln -s /etc/apache2/sites-available/local.m2docker.conf /etc/apache2/sites-enabled/local.m2docker.conf
RUN service apache2 restart