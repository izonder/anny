# ANNY - a slim docker container image

**ANNY** = **A**lpine + **N**ginx + **N**ode.js + **Y**arn

[![](https://images.microbadger.com/badges/version/izonder/anny:8.svg)](https://microbadger.com/images/izonder/anny:8 "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/izonder/anny:8.svg)](https://microbadger.com/images/izonder/anny:8 "Get your own image badge on microbadger.com")
[![Build Status](https://travis-ci.org/izonder/anny.svg?branch=nodejs-8)](https://travis-ci.org/izonder/anny)

## Breaking changes

Due to [Node.js LTS schedule](https://github.com/nodejs/Release) we have released major upgrade, which contains:
- Alpine Linux v.3.6.x
- Node.js v.8.x.x
- Yarn v.1.x.x (stable)
- S6-overlay v.1.20.x.x

Please make sure these changes won't affect your functionality. Also be aware the children images [`izonder/janny`](https://hub.docker.com/r/izonder/janny/) and  [`izonder/lanny`](https://hub.docker.com/r/izonder/lanny/) are also rebuilt based on `izonder/anny:latest`.  

## Supported tags and respective `Dockerfile` links
- `latest` [(Dockerfile)](https://github.com/izonder/anny/blob/master/Dockerfile)
- `10` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-10/Dockerfile)
- `8` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-8/Dockerfile)
- `6` [(Dockerfile)](https://github.com/izonder/anny/blob/nodejs-6/Dockerfile)

## Features

- Alpine linux as base-image
- S6-overlay to run multiple processes in container
- Nginx with basic configuration
- Node.js (fully-static without NPM)
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
