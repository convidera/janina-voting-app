# progrlang-vote-app

# Project setup

Rename all .env.example to .env and provide your passwords before running the up command. MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER and MYSQL_PASSWORD are not predefined and can be freely chosen by the user. SECRET_KEY should be genereted by Django. The GITHUB_ and SERVER_ environment variables are only needed by devops script commands pullserver and sshserver.

## Generate Django Secret Key

https://djecrety.ir/

# Generate self-signed certificates with mkcert for local environment and Let's Encrypt certificates for stage environment.

# Set up a local DNS like Dnsmasq (Mac OS) for local environment in order to direct traffic from test domain to localhost.

https://passingcuriosity.com/2013/dnsmasq-dev-osx/

# Build frontend and backend images for local environment:
Go to frontend and backend project folders.

```bash
docker build --target dev-stage -t alonimacaroni/frontend-part:local .
docker build --target dev-stage -t alonimacaroni/backend-part:local .
```

or build from project root

```bash
./devops.sh build frontend-part
./devops.sh build backend-part
```

or build all from project root:

```bash
./devops.sh build
```

# Build frontend and backend images for stage environment:

```bash
docker build --target prod-stage -t alonimacaroni/frontend-part:stage .
docker build --target prod-stage -t alonimacaroni/backend-part:stage .
```

# Build frontend and backend images for ci environment:

```bash
docker build --target dev-stage -t alonimacaroni/frontend-part:ci .
docker build --target dev-stage -t alonimacaroni/backend-part:ci .
```

# Apply migrations (here: local):

```bash
./devops.sh migrate
```

# Run command (use devops.sh) against service:

```bash
LOC=stage ./devops.sh run --rm <service> <command>
```

```bash
LOC=stage ./devops.sh exec --rm <service> <command>
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