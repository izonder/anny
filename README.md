# ANNY - a slim docker container image

**ANNY** = **A**lpine + **N**ginx + **N**ode.js + **Y**arn

[![](https://images.microbadger.com/badges/version/izonder/anny.svg)](https://microbadger.com/images/izonder/anny "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/izonder/anny.svg)](https://microbadger.com/images/izonder/anny "Get your own image badge on microbadger.com")
[![Build Status](https://travis-ci.org/izonder/anny.svg?branch=master)](https://travis-ci.org/izonder/anny)

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
