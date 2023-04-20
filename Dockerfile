# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# Install apache 2 server

RUN apt update
RUN apt install -y apache2
RUN apt install -y apache2-utils
RUN apt clean
EXPOSE 80
CMD ["apache2ctl", "-D", "FOURGROUND"]