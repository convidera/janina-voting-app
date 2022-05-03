# progrlang-vote-app

# Project setup

## Run all containers at once:

Rename .env.example to .env and provide your password before running the up command.

```bash
docker-compose up -d
```

## Execute a command in a service in running app:

```bash
docker-compose run <service> <command> 
```


# Open in browser:
[localhost:8080](http://localhost:8080/)


# Setup App:

## Build frontend and backend images:

```bash
docker build -t alonimacaroni/frontend-part .
docker build -t alonimacaroni/backend-part .
```

## Build node modules in frontend root folder:

```bash
npm install
```

## Test single containers:

```bash
docker run -it -p 8080:8080 --name frontend-part alonimacaroni/frontend-part
```

## Test database container:
MySQL image is pulled automatically if it does not exist.

```bash
docker run --name vote-app-mysql -v mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.0
```

# Use devops.sh bash script for executing commands in a service in running app:

Make devops.sh executable (Mac OS, Linux):

```bash
chmod +x devops.sh
```

Execute script:

```bash
./devops.sh
```

## Script commands:

Without command options script runs:

```bash
docker-compose up
```

Shut down app:

```bash
./devops exit
```

\
\
Run server in backend, more options for original command can be appended:

```bash
./devops runserver
```

This is the same as:

```bash
python manage.py runserver
```

\
\
Apply changes to database:

```bash
./devops migrate
```

Create migrations:

```bash
./devops makemigrations
```

Reset database:

```bash
./devops flush
```

\
\
Run server in frontend, more options for original command can be appended:

```bash
./devops npm
```

This is the same as:

```bash
npm run serve
```

\
\
Execute tests on backend-part:

```bash
./devops test
```

\
\
Push changes to github:

```bash
./devops push "<message>"
```
