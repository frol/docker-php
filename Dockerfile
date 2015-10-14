FROM vibioh/nginx:latest
MAINTAINER Vincent Boutour <vincent.boutour@gmail.com>

COPY ./entrypoint.sh /

ENV WORDPRESS_VERSION latest

USER root
RUN apk --update add php-fpm php-mysql php-zlib php-curl \
 && chown -R nginx:nogroup /var/log/ \
 && sed -i "s/^\}$/    include \/var\/www\/php\.conf;\n\}/" /etc/nginx/sites-enabled/localhost
 && chmod +x /entrypoint.sh \
 && rm -rf /var/cache/apk/*

COPY ./php.conf /var/www/php.conf

VOLUME /var/log

USER nginx

ENTRYPOINT [ "/entrypoint.sh" ]
