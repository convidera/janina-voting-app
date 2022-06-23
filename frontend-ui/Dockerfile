# build stage
FROM node:lts-alpine as build-stage
RUN npm install -g npm@latest
COPY . /app
WORKDIR /app
COPY package*.json ./
RUN npm install
RUN npm run build

# development stage
FROM node:lts-alpine as dev-stage
COPY --from=build-stage /app /app
RUN npm install -g http-server
EXPOSE 8080
CMD ["http-server", "dist"]

# production stage
FROM nginx:stable-alpine as prod-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]