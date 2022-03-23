FROM node:alpine

RUN npm install vue
RUN npm install -g @vue/cli

COPY . /app
WORKDIR /app/voting-app

RUN npm run serve