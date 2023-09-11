# IMPORTANT! Alpine 3.18 requires having Docker 23+
# Release notes: https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.18.0#Docker_23
FROM node:18.17.1-alpine3.18

MAINTAINER Dmitry Morgachev <izonder@gmail.com>

ENV S6_VERSION=v3.1.5.0

RUN set -eux \
\
##############################################################################
# Create source directory and install dependencies
##############################################################################
\
    && mkdir /src \
    && apk add --no-cache libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
\
##############################################################################
# Install S6-overlay
##############################################################################
\
    && ARCH="$(apk --print-arch)" \
    && curl -o /tmp/s6-overlay-noarch.tar.xz -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-noarch.tar.xz \
    && tar -Jxpf /tmp/s6-overlay-noarch.tar.xz -C / \
    && curl -o /tmp/s6-overlay-bin.tar.xz -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${ARCH}.tar.xz \
    && tar -Jxpf /tmp/s6-overlay-bin.tar.xz -C / \
\
##############################################################################
# Install Nginx
##############################################################################
\
    && apk add --no-cache nginx \
    && rm -rf /etc/nginx/http.d \
    && mkdir /etc/nginx/conf.d \
\
##############################################################################
# Clean up
##############################################################################
\
    && apk del .build-deps \
    && rm -rf \
        /tmp/* \
        /var/cache/apk/* \
        /etc/nginx/conf.d/* \
        /usr/share/man

##############################################################################
# Configs and init scripts
##############################################################################

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./service/ /etc/services.d/

EXPOSE 80 443 3000
ENTRYPOINT ["/init"]
