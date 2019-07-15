FROM php:7.1-apache
MAINTAINER Yoann Ono Dit Biot <yoann.onoditbiot@tedomum.net>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y supervisor libicu-dev
RUN docker-php-ext-install pcntl mysqli pdo_mysql opcache intl

WORKDIR /var/www/html
COPY ./ /var/www/html
RUN cp config.php-dist config.php
RUN chown www-data:www-data -R /var/www/html

EXPOSE 80

# complete path to ttrss
ENV SELF_URL_PATH http://localhost

# expose default database credentials via ENV in order to ease overwriting
ENV DB_NAME ttrss
ENV DB_USER ttrss
ENV DB_PASS ttrss


ADD docker/configure-db.php /configure-db.php
ADD docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD php /configure-db.php && supervisord -c /etc/supervisor/conf.d/supervisord.conf
