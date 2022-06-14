FROM node:lts-alpine


RUN npm install -g http-server


COPY . /app
WORKDIR /app

COPY package*.json ./


RUN npm install -g npm@latest
RUN npm install

RUN npm run build

EXPOSE 8080
CMD ["http-server", "dist"]