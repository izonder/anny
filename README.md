# ANNY - a slim docker container image

**ANNY** = **A**lpine + **N**ginx + **N**ode.js + **Y**arn

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
