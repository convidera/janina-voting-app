#! /bin/bash
COMPOSE="docker-compose"

function install() {
    ENV=${1:-local}
    cp -n .deploy/${ENV}/docker-compose.yml  docker-compose.yml || true
    cp -n backend/.env.example               backend/.env       || true
    cp -n frontend/.npmrc.example            frontend/.npmrc    || true
    cp -n .env.example                       .env               || true
}

if [ $# -gt 0 ]
then
  if [ "$1" == "exit" ];then
    $COMPOSE down
  elif [ "$1" == "runserver" ];then
    shift 1
    $COMPOSE run --rm \
      backend-part \
      python manage.py runserver "$@"
  elif [ "$1" == "migrate" ];then
    $COMPOSE run --rm \
      backend-part \
      python manage.py migrate
  elif [ "$1" == "makemigrations" ];then
    $COMPOSE run --rm \
      backend-part \
      python manage.py makemigrations showvotes
  elif [ "$1" == "flush" ];then
    $COMPOSE run --rm \
      backend-part \
      python manage.py flush
  elif [ "$1" == "npm" ]; then
    shift 1
    $COMPOSE run --rm \
      frontend-part \
      npm run serve "$@"
  elif [ "$1" == "test" ];then
    shift 1
    $COMPOSE run --rm \
      backend-part \
      pytest "$@"
  elif [ "$1" == "push" ];then 
    git add * && \
    git commit -m "$2" && \
    shift 2
    git push "$@"
  elif [ "$1" == "pullserver" ];then
    #check if .env exists
    if [ -f .env ]; then
      #import environment variables from .env
      export $(cat .env | xargs)
      #check if GITHUB_USER and GITHUB_TOKEN strings exist in .env
      if grep -Fq GITHUB_USER .env && grep -Fq GITHUB_TOKEN .env
      then
        #check if variables are unset
        if [ -z "$GITHUB_USER" ] && [ -z "$GITHUB_TOKEN" ];then
          echo "environment variables unset in .env file"
        else
          ./pullserverbot.exp $GITHUB_USER $GITHUB_TOKEN
        fi
      else
        echo "environment variables missing in .env file"
      fi
    else
      echo ".env file missing"
    fi
  elif [ "$1" == "sshserver" ];then
    if [ -f .env ]; then
      export $(cat .env | xargs)
      if grep -Fq SERVER_USER .env && grep -Fq SERVER_IP .env && grep -Fq SERVER_PASSPHRASE .env
      then
        if [ -z "$SERVER_USER" ] && [ -z "$SERVER_IP" ] && [ -z "$SERVER_PASSPHRASE" ];then
          echo "environment variables unset in .env file"
        else
          ./sshserverbot.exp $SERVER_USER $SERVER_IP $SERVER_PASSPHRASE
        fi
      else
        echo "environment variables missing in .env file"
      fi
    else
      echo ".env file missing"
    fi
  else
    $COMPOSE "$@"
  fi
else
  $COMPOSE up
fi
