FROM vibioh/nginx:latest
MAINTAINER Vincent Boutour <vincent.boutour@gmail.com>

COPY ./entrypoint.sh /

USER root
RUN apk --update add php-fpm php-mysql php-zlib php-curl php-xmlrpc php-ctype php-json php-openssl php-gd \
 && chown -R nginx:nogroup /var/log/ \
 && sed -i "s/^\}$/    include \/var\/www\/php\.conf;\n\}/" /etc/nginx/sites-enabled/localhost \
 && server_port_configuration='fastcgi_param  SERVER_PORT        $server_port;' \
 && patched_server_port_configuration="$(echo \
      'if ($http_x_forwarded_port != false) {' \
      '\n   set $_server_port $http_x_forwarded_port;' \
      '\n}' \
      '\nif ($_server_port = false) {' \
      '\n    set $_server_port $server_port;' \
      '\n}' \
      '\nfastcgi_param SERVER_PORT $_server_port;' \
    )" \
 && sed -i "s/$server_port_configuration/$patched_server_port_configuration/" /etc/nginx/fastcgi.conf \
 && chmod +x /entrypoint.sh \
 && sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php/php.ini \
 && sed -i "s/post_max_size = 8M/post_max_size = 32M/" /etc/php/php.ini \
 && rm -rf /var/cache/apk/*

COPY ./php.conf /var/www/php.conf

VOLUME /var/log

USER nginx

ENTRYPOINT [ "/entrypoint.sh" ]
