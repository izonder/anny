# IMPORTANT! Alpine 3.14 requires having Docker 20.10+
# Original issue: https://github.com/alpinelinux/docker-alpine/issues/182
# Release notes: https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.14.0#faccessat2
FROM alpine:3.14

MAINTAINER Dmitry Morgachev <izonder@gmail.com>

ENV S6_VERSION=v2.2.0.3 \
    NODE_VERSION=v16.20.0 \
    NODE_PREFIX=/usr \
    NODE_RELEASE_KEYS=https://raw.githubusercontent.com/nodejs/release-keys/HEAD \
    YARN_VERSION=v1.22.19 \
    YARN_PREFIX=/usr/share/yarn \
    YARN_BINARY=/usr/bin

RUN set -eux \
\
##############################################################################
# Create source directory and prepare user
##############################################################################
\
    && addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && mkdir /src \
\
##############################################################################
# Install dependencies
##############################################################################
\
    && apk add --no-cache libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python3 \
\
##############################################################################
# Install S6-overlay
##############################################################################
\
    && curl -o /tmp/s6-overlay-amd64.tar.gz -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
    && tar -zxf /tmp/s6-overlay-amd64.tar.gz -C / \
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
# Install Node
# Based on https://github.com/mhart/alpine-node/blob/master/Dockerfile (thank you)
##############################################################################
\
    # gpg keys from https://github.com/nodejs/release-keys \
    && for KEY_ID in $(curl -sSL "${NODE_RELEASE_KEYS}/keys.list" | xargs); do \
        curl -sSL "${NODE_RELEASE_KEYS}/keys/${KEY_ID}.asc" | gpg --import; \
    done \
\
    # Download and validate the NodeJs source
    && mkdir /node_src \
    && cd /node_src \
    && curl -o node-${NODE_VERSION}.tar.gz -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz \
    && curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc \
    && gpg --verify SHASUMS256.txt.asc \
    && grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - \
\
    # Compile and install
    && cd /node_src \
    && tar -zxf node-${NODE_VERSION}.tar.gz \
    && cd node-${NODE_VERSION} \
    && ./configure --prefix=${NODE_PREFIX} --without-npm \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
\
##############################################################################
# Install yarn
##############################################################################
\
    && for server in \
       keyserver.ubuntu.com \
       keys.openpgp.org \
   ; do \
       gpg --keyserver $server --recv-keys \
            6A010C5166006599AA17F08146C2130DFD2497F5 \
        && break; \
    done \
\
    # Download, validate and install the Yarn source
    && curl -o /tmp/yarn-${YARN_VERSION}.tar.gz -sSL https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz \
    && curl -o /tmp/yarn-${YARN_VERSION}.tar.gz.asc -sSL https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz.asc \
    && gpg --verify /tmp/yarn-${YARN_VERSION}.tar.gz.asc \
    && tar -zxf /tmp/yarn-${YARN_VERSION}.tar.gz -C /tmp \
    && mv -f /tmp/yarn-${YARN_VERSION} ${YARN_PREFIX} \
    && ln -sf ${YARN_PREFIX}/bin/yarn ${YARN_BINARY}/yarn \
    && ln -sf ${YARN_PREFIX}/bin/yarnpkg ${YARN_BINARY}/yarnpkg \
\
##############################################################################
# Clean up
##############################################################################
\
    && apk del .build-deps \
    && rm -rf \
        /node_src \
        /tmp/* \
        /var/cache/apk/* \
        /etc/nginx/conf.d/* \
        /usr/share/man

##############################################################################
# Configs and init scripts
##############################################################################

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./service/* /etc/services.d/*

EXPOSE 80 443 3000
ENTRYPOINT ["/init"]
