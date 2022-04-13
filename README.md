# progrlang-vote-app

# Project setup

## Run all containers at once:

Rename .env.example to .env and provide your password before running the up command.

```bash
docker-compose up -d
```


# Open in browser:
[localhost:8080](http://localhost:8080/)


# Test single containers:

## Build frontend and backend images and run single frontend container:

```bash
docker build -t alonimacaroni/vote-frontend .
docker build -t alonimacaroni/vote-backend .
```

```bash
docker run -it -p 8080:8080 --name frontend-part alonimacaroni/vote-frontend
```

## Run single database container:
MySQL image is pulled automatically if it does not exist.

```bash
docker run --name vote-app-mysql -v mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.0
```
