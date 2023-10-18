ARG PHP_VERSION=8.1
ARG NODE_VERSION=18.18.2

FROM node:${NODE_VERSION}-alpine AS node

FROM php:${PHP_VERSION}-fpm-alpine
# APPUSER_ID is defined in the docker-compose.yml
ARG APPUSER_ID

# Create "host" user
RUN adduser --uid ${APPUSER_ID} --disabled-password appuser

WORKDIR /app

RUN apk add --no-cache \
        curl \
        bash \
        git \
    ;

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN set -eux; \
    install-php-extensions \
        http \
		apcu \
		intl \
		opcache \
		zip \
        pdo \
        pdo_mysql \
    ;

COPY --link .docker/php/conf.d/app.ini $PHP_INI_DIR/conf.d/

# https://getcomposer.org/doc/03-cli.md#composer-allow-superuser
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"
COPY --from=composer/composer:2-bin --link /composer /usr/bin/composer

# Access private repositories in Docker
# https://dunglas.dev/2022/08/securely-access-private-git-repositories-and-composer-packages-in-docker-builds/

# NODE
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin
RUN node -v
RUN npm install -g yarn --force
RUN yarn -v

ENV APP_ENV=dev

RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' |  bash
RUN apk add symfony-cli

CMD ["symfony", "server:start"]

