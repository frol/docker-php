FROM vibioh/nginx:latest
MAINTAINER Vincent Boutour <vincent.boutour@gmail.com>

COPY ./entrypoint.sh /

ENV WORDPRESS_VERSION latest

USER root
RUN apk --update add php-fpm php-mysql php-zlib php-curl \
 && chown -R nginx:nogroup /var/log/ \
 && chmod +x /entrypoint.sh \
 && sed -i "s/^\}$/    include \/etc\/nginx\/sites\-enabled\/php\.conf;\n\}/" /etc/nginx/sites-enabled/localhost \
 && rm -rf /var/cache/apk/*

COPY ./php.conf /etc/nginx/sites-enabled/php.conf

VOLUME /var/log

USER nginx

ENTRYPOINT [ "/entrypoint.sh" ]
