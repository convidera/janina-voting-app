FROM node:alpine


RUN npm install -g http-server

COPY . /app
WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 8080
CMD ["http-server", "dist"]