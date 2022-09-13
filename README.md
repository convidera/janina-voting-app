# progrlang-vote-app

# Project setup

Rename all .env.example to .env and provide your passwords before running the start app command. If you specify ci environment copy the .env files to a server space. MYSQL_ROOT_PASSWORD, MYSQL_DATABASE, MYSQL_USER and MYSQL_PASSWORD are not predefined and can be freely chosen by the user. SECRET_KEY should be genereted by Django. The GITHUB_ and SERVER_ environment variables are only needed by devops script commands pullserver and sshserver.

## Generate Django Secret Key

https://djecrety.ir/

Generate self-signed certificates with mkcert for local environment and Let's Encrypt certificates for stage environment.

Set up a local DNS like Dnsmasq (Mac OS) for local environment in order to direct traffic from test domain to localhost.

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

## Build all images at once:

select corresponding LOC parameter:

```bash
LOC=stage ./devops.sh setup
```

# Use devops.sh script for app management:
Set LOC parameter equal to local (default), ci, stage, op or exec.

## Start app correctly:
```bash
LOC=stage ./devops.sh
```
Wait for database connection:
```bash
LOC=exec ./devops.sh wait
```
Apply migrations.
## Shutdown app correctly:
local: 
```bash
LOC=exec ./devops.sh exit
```
stage: 
```bash
LOC=exec ./devops.sh exitstage
```
ci: 
```bash
LOC=exec ./devops.sh exitci
```
## Docker dependent command options, executed in new container (local, ci, stage):
All command options are also available by setting LOC=exec in order to execute commands in running container.

Apply migrations:
```bash
LOC=stage ./devops.sh migrate
```
Make migrations:
```bash
LOC=stage ./devops.sh makemig
```
Reset Database:
```bash
LOC=stage ./devops.sh flush
```
Run automated tests:
```bash
LOC=stage ./devops.sh test
```
## Administrative tasks on host:
Push code to Github:
```bash
LOC=op ./devops.sh push
```
Pull code from Github:
```bash
LOC=op ./devops.sh pull
```
SSH to server:
```bash
LOC=op ./devops.sh sshserver
```
Reset and clean Docker environment:
```bash
LOC=op ./devops.sh clean
```