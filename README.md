# progrlang-vote-app

# Project setup

##Build frontend image and run single frontend container:

```bash
docker build -t alonimacaroni/vote-frontend .
```

```bash
docker run -it -p 8080:8080 --rm --name frontend-part alonimacaroni/vote-frontend
```

##Run single database container:
MySQL image is pulled automatically if it does not exist.

```bash
docker run --name vote-app-mysql -v mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.0
```

##Open in browser:
[localhost:8080] (localhost:8080)
