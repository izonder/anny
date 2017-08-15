FROM alpine:3.4

MAINTAINER Dmitry Morgachev <izonder@gmail.com>

ENV S6_VERSION=v1.19.1.1 \
    NODE_VERSION=v6.11.2 \
    NODE_PREFIX=/usr \
    YARN_VERSION=v0.27.5 \
    YARN_PREFIX=/usr/share/yarn \
    YARN_BINARY=/usr/bin

RUN set -x \

##############################################################################
# Create source directory
##############################################################################

    && mkdir /src \

##############################################################################
# Install dependencies
##############################################################################

    && apk add --no-cache \
        ca-certificates \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        libstdc++ \
        linux-headers \
        make \
        paxctl \
        python \

##############################################################################
# Install S6-overlay
##############################################################################

    && curl -o /tmp/s6-overlay-amd64.tar.gz -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
    && tar -zxf /tmp/s6-overlay-amd64.tar.gz -C / \

##############################################################################
# Install Nginx
##############################################################################

    && apk add --no-cache nginx \
    && rm -rf /etc/nginx/default.d \

##############################################################################
# Install Node
# Based on https://github.com/mhart/alpine-node/blob/master/Dockerfile (thank you)
##############################################################################

    # Download and validate the NodeJs source
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys \
        9554F04D7259F04124DE6B476D5A82AC7E37093B \
        94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
        0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
        FD3A5288F042B6850C66B31F09FE44734EB7990E \
        71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
        DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
        C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
        B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    && mkdir /node_src \
    && cd /node_src \
    && curl -o node-${NODE_VERSION}.tar.gz -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz \
    && curl -o SHASUMS256.txt.asc -sSL https://nodejs.org/dist/${NODE_VERSION}/SHASUMS256.txt.asc \
    && gpg --verify SHASUMS256.txt.asc \
    && grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt.asc | sha256sum -c - \

    # Compile and install
    && cd /node_src \
    && tar -zxf node-${NODE_VERSION}.tar.gz \
    && cd node-${NODE_VERSION} \
    && export GYP_DEFINES="linux_use_gold_flags=0" \
    && ./configure --prefix=${NODE_PREFIX} --without-npm --fully-static \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && make -j${NPROC} -C out mksnapshot BUILDTYPE=Release \
    && paxctl -cm out/Release/mksnapshot \
    && make -j${NPROC} \
    && make install \
    && paxctl -cm ${NODE_PREFIX}/bin/node \

##############################################################################
# Install yarn
##############################################################################

    && mkdir /tmp/yarn-${YARN_VERSION} \
    && curl -o /tmp/yarn-${YARN_VERSION}.tar.gz -sSL https://github.com/yarnpkg/yarn/releases/download/${YARN_VERSION}/yarn-${YARN_VERSION}.tar.gz \
    && tar -zxf /tmp/yarn-${YARN_VERSION}.tar.gz -C /tmp/yarn-${YARN_VERSION} \
    && mv -f /tmp/yarn-${YARN_VERSION}/dist ${YARN_PREFIX} \
    && sed -i "s|^basedir=.*$|basedir=${YARN_PREFIX}/bin|" ${YARN_PREFIX}/bin/yarn \
    && ln -sf ${YARN_PREFIX}/bin/yarn ${YARN_BINARY}/yarn \
    && ln -sf ${YARN_PREFIX}/bin/yarn ${YARN_BINARY}/yarnpkg \

##############################################################################
# Clean up
##############################################################################

    && apk del \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        libstdc++ \
        linux-headers \
        make \
        paxctl \
        python \

    && rm -rf \
        /node_src \
        /tmp/* \
        /var/cache/apk/* \
        ${NODE_PREFIX}/share/man \
        ${NODE_PREFIX}/lib/node_modules \
        ${NODE_PREFIX}/include

##############################################################################
# Configs and init scripts
##############################################################################

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./service/* /etc/services.d/*

EXPOSE 80 443 3000
ENTRYPOINT ["/init"]
