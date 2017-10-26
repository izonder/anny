# ANNY - a slim docker container image

**ANNY** = **A**lpine + **N**ginx + **N**ode.js + **Y**arn

[![](https://images.microbadger.com/badges/version/izonder/anny.svg)](https://microbadger.com/images/izonder/anny "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/izonder/anny.svg)](https://microbadger.com/images/izonder/anny "Get your own image badge on microbadger.com")
[![Build Status](https://travis-ci.org/izonder/anny.svg?branch=master)](https://travis-ci.org/izonder/anny)

## IMPORTANT! Breaking changes announcement

Due to [Node.js LTS schedule](https://github.com/nodejs/Release) we have released major upgrade, which contains:
- Alpine Linux v.3.6.x
- Node.js v.8.x.x
- Yarn v.1.x.x (stable)
- S6-overlay v.1.20.x.x

Please make sure these changes won't affect your functionality. Also be aware the children images [`izonder/janny`](https://hub.docker.com/r/izonder/janny/) and  [`izonder/lanny`](https://hub.docker.com/r/izonder/lanny/) are also rebuilt based on `izonder/anny:latest`.  

If you still need `izonder/anny` based on Node.js v6.x.x use the image `izonser/anny:6` instead of `latest`.

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
