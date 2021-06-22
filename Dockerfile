#------------------ DOCKER CONFIGURATION ------------------

#Primera Etapa
FROM node:14-alpine as build-step

RUN node --version 

RUN mkdir -p /app

WORKDIR /app

COPY package.json /app

RUN npm install npm@7.17.0

RUN npm install

#Update jasmine pkgs !IMPORTANT
RUN npm install jasmine-core@latest
RUN npm install karma-jasmine-html-reporter@latest
RUN npm install @types/jasmine@latest

COPY . /app

RUN npm run build

#Segunda Etapa
FROM nginx:1.17.1-alpine

USER root

COPY --from=build-step /app/dist/angular-tour-of-heroes8 /usr/share/nginx/html