# build stage
FROM node:lts-alpine as build-stage
RUN npm install -g npm@latest
COPY . /frontend-ui
WORKDIR /frontend-ui
COPY package*.json ./
RUN npm install
RUN npm run build

# development stage
FROM node:lts-alpine as dev-stage
COPY --from=build-stage /app . 
RUN npm install -g http-server
EXPOSE 8080
CMD ["http-server", "dist"]

# production stage
FROM nginx:stable-alpine as prod-stage
COPY --from=build-stage /frontend-ui/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]