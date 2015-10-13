# docker-php

[![](https://badge.imagelayers.io/vibioh/php:latest.svg)](https://imagelayers.io/?images=vibioh/php:latest 'Get your own badge on imagelayers.io')

Creating light image for a php-enabled nginx based on Alpine Linux.

## Usage

    docker run \
      -d \
      -p 1080:80 \
      -p 10443:443 \
      --name test_php \
      --read-only \
      vibioh/php:latest

After, simply browse [homemage](http://localhost:1080/) to see content in `/var/www/localhost`.
