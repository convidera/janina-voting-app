# progrlang-vote-app

# Project setup

Rename all .env.example to .env and provide your passwords before running the up command. MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER and MYSQL_PASSWORD are not predefined and can be freely chosen by the user. SECRET_KEY should be genereted by Django. The GITHUB_ and SERVER_ environment variables are only needed by devops script commands pullserver and sshserver.

## Generate Django Secret Key

https://djecrety.ir/

## Generate self-signed certificates with mkcert for local environment and Let's Encrypt certificates for stage environment.

## Set up a local DNS like Dnsmasq (Mac OS) for local environment in order to direct traffic from test domain to localhost.

https://passingcuriosity.com/2013/dnsmasq-dev-osx/

# Build images:

## Build frontend and backend images for local environment:
Go to frontend and backend project folders.

```bash
docker build --target dev-stage -t alonimacaroni/vote-frontend:local .
docker build --target dev-stage -t alonimacaroni/vote-backend:local .
```

## Build frontend and backend images for stage environment:

```bash
docker build --target prod-stage -t alonimacaroni/vote-frontend:stage .
docker build --target prod-stage -t alonimacaroni/vote-backend:stage .
```

## Build backend image for ci environment:

mysql:8.0 image needs to be pulled from Dockerhub.

```bash
docker build --target dev-stage -t alonimacaroni/vote-backend:ci .
```

## Build all images at once:

select corresponding LOC parameter:

```bash
./devops.sh setup
```

# Start app correctly:

```bash
./devops.sh
```

# Shutdown app correctly:

```bash
LOC=exec ./devops.sh exit
```

# Bring app up:

Start app:

```bash
./devops.sh
```

Apply migrations:

```bash
LOC=exec ./devops.sh migrate
```

# Script commands:

## one-time app commands (start and shutdown):

All one-time commands work for local, stage and ci environments.

Apply migrations:

```bash
LOC=stage ./devops.sh migrate
```

Make migrations:

```bash
LOC=stage ./devops.sh makemigrations
```

Empty database:

```bash
LOC=stage ./devops.sh flush
```

Run tests in backend:

```bash
LOC=stage ./devops.sh test
```

## app independent commands:

Choose LOC=op option:

Push to github:

```bash
LOC=op ./devops.sh push
```

Pull github files to server:

```bash
LOC=op ./devops.sh pullserver
```

Log in to server via SSH:

```bash
LOC=op ./devops.sh sshserver
```

Reset app environment:

```bash
LOC=op ./devops.sh clean
```

## running app commands:

Apply migrations:

```bash
LOC=exec ./devops.sh migrate
```

Run tests in backend:

```bash
LOC=exec ./devops.sh test
```