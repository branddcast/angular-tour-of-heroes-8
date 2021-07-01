#------------------ DOCKER CONFIGURATION ------------------

# #Primera Etapa
# FROM node:14-alpine as build-step

# RUN node --version 

# RUN mkdir -p /app

# WORKDIR /app

# COPY package.json /app

# RUN npm install npm@7.17.0

# RUN npm install

# #Update jasmine pkgs !IMPORTANT
# RUN npm install jasmine-core@latest
# RUN npm install karma-jasmine-html-reporter@latest
# RUN npm install @types/jasmine@latest

# COPY . /app

# RUN npm run build

# #Segunda Etapa
FROM registry.redhat.io/rhel8/nginx-116

# Add application sources to a directory that the assemble script expects them
# and set permissions so that the container runs without root access
USER 0
ADD test-app /tmp/src/
RUN chown -R 1001:0 /tmp/src
USER 1001

# Let the assemble script to install the dependencies
RUN /usr/libexec/s2i/assemble

RUN /bin/sh -c source /opt/app-root/src/sh/$SH_FILE.sh; envsubst < /opt/app-root/src/assets/env.template.js > /opt/app-root/src/assets/env.js; rm -rf /opt/app-root/src/sh

# Run script uses standard ways to run the application
CMD /usr/libexec/s2i/run

USER root

COPY --from=build-step /app/.sh /usr/share/nginx/env
COPY --from=build-step /app/dist/angular-tour-of-heroes8 /usr/share/nginx/html