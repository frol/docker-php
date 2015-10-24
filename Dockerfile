FROM vibioh/nginx:latest
MAINTAINER Vincent Boutour <vincent.boutour@gmail.com>

COPY ./entrypoint.sh /

USER root
RUN apk --update add php-fpm php-mysql php-zlib php-curl \
 && chown -R nginx:nogroup /var/log/ \
 && sed -i "s/^\}$/    include \/var\/www\/php\.conf;\n\}/" /etc/nginx/sites-enabled/localhost \
 && chmod +x /entrypoint.sh \
 && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php/php.ini \
 && sed -i "s/post_max_size = 8M/post_max_size = 32M/" /etc/php/php.ini \
 && rm -rf /var/cache/apk/*

COPY ./php.conf /var/www/php.conf

VOLUME /var/log

USER nginx

ENTRYPOINT [ "/entrypoint.sh" ]
