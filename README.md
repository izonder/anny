# ANNY - a slim docker container image

**ANNY** = **A**lpine + **N**ginx + **N**ode.js + **Y**arn

[![Build Docker image](https://github.com/izonder/anny/actions/workflows/docker-image.yml/badge.svg?branch=nodejs-18)](https://github.com/izonder/anny/actions/workflows/docker-image.yml)

## Breaking changes

Due to [Node.js LTS schedule](https://github.com/nodejs/Release) we have released major upgrade, which contains:
- Alpine Linux v3.18.x
- Node.js v18.x.x
- Yarn v1.x.x
- S6-overlay v3.1.x.x
- Nginx v1.20.x

Please make sure these changes won't affect your functionality. Also be aware the children images [`izonder/janny`](https://hub.docker.com/r/izonder/janny/) and  [`izonder/lanny`](https://hub.docker.com/r/izonder/lanny/) are also rebuilt based on `izonder/anny:latest`.

## Supported tags and respective `Dockerfile` links
- `latest` [(Dockerfile)](https://github.com/izonder/anny/blob/master/Dockerfile)
- `18` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-18/Dockerfile)
- `16` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-16/Dockerfile)
- `14` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-14/Dockerfile)
- `12` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-12/Dockerfile)
- `10` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-10/Dockerfile)
- `8` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-8/Dockerfile)
- `6` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-6/Dockerfile)

## Features

- Alpine linux as base-image
- S6-overlay to run multiple processes in container
- Nginx with basic configuration
- Node.js (without NPM)
- Yarn package manager

## How to use?

```
FROM izonder/anny:latest

...

# add new service
COPY ./service/myservice.sh /etc/services.d/myservice/run

...

# add nginx configuration
COPY ./nginx/myapp.conf /etc/nginx/conf.d/myapp.conf

...

# install dependencies
RUN yarn install

...

# entry point
CMD ["node", "myapp.js"]
```
