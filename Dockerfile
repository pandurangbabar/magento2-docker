# syntax=docker/dockerfile:1
FROM php:8.1-apache 

#Apache2 configuration for magento 2
RUN a2enmod rewrite
RUN service apache2 restart