# progrlang-vote-app

# Project setup

Rename .env.example to .env and provide your password before running the up command. MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER and MYSQL_PASSWORD are not predefined and can be freely chosen by the user. The GITHUB_ and SERVER_ environment variables are only needed by devops script commands pullserver and sshserver.

# Build frontend and backend images:

```bash
docker build -t alonimacaroni/frontend-part .
docker build -t alonimacaroni/backend-part .
```

# Build node modules in frontend root folder:

```bash
npm install
```

# Makemigrations and apply migrations (see devops.sh).

# local environment: Create a docker network called proxy in project root:

```bash
docker network create proxy
```

# stage environment: 

## In frontend-ui folder:

Create a folder named dist.

```bash
npm run build
```

## For vote_app_backend (use devops.sh):

```bash
LOC=stage ./devops.sh run --rm backend-part python manage.py collectstatic
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
Without command options script runs:

```bash
docker-compose up
```

## Script commands:

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
gunicorn vote_app_backend.wsgi:application
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

\
\
Pull changes from github to server:

```bash
./devops pullserver
```

\
\
Login to server via SSH:

```bash
./devops sshserver
```