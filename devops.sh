#!/bin/bash
set -euo pipefail
COMPOSE="docker-compose"
COPIED=false
export LOC=${LOC:-local}
ABORT=true

function install() {
  if [ "$LOC" == "local" ];then
    docker network create proxy
    if [ ! -f docker-compose.yml ] && [ ! -f frontend-ui/vue.config.js ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/vue.config.js frontend-ui/vue.config.js || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
      COPIED=true
      ABORT=false
    fi
  fi
  if [ "$LOC" == "ci" ];then
    if [ ! -f docker-compose.yml ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
      COPIED=true
      ABORT=false
    fi
  fi
  if [ "$LOC" == "stage" ];then
    if [ ! -f docker-compose.yml ] && [ ! -f frontend-ui/vue.config.js ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/vue.config.js frontend-ui/vue.config.js || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
      COPIED=true
      ABORT=false
    fi
  fi
}

function cleanUp() {
  $COMPOSE down
  if [ "$COPIED" = true ];then
    rm docker-compose.yml
    rm vote_app_backend/vote_app_backend/settings.py
    if [ -f frontend-ui/vue.config.js ];then
      rm frontend-ui/vue.config.js
    fi
    if [ "$LOC" == "local" ];then
      docker network rm proxy
    fi
  fi
}

if [ $# -gt 0 ]
then
  if [ "$1" == "runserver" ];then
    install
    if [ $ABORT = false ];then
      shift 1
      $COMPOSE run --rm \
        backend-part \
        gunicorn vote_app_backend.wsgi:application "$@"
      cleanUp
    fi
  elif [ "$1" == "migrate" ];then
    install
    if [ $ABORT = false ];then
      $COMPOSE run --rm \
        backend-part \
        python manage.py migrate
      cleanUp
    fi
  elif [ "$1" == "makemigrations" ];then
    install
    if [ $ABORT = false ];then
      $COMPOSE run --rm \
        backend-part \
        python manage.py makemigrations showvotes
      cleanUp
    fi
  elif [ "$1" == "flush" ];then
    install
    $COMPOSE run --rm \
      backend-part \
      python manage.py flush
    cleanUp
  elif [ "$1" == "npm" ]; then
    install
    if [ $ABORT = false ];then
      shift 1
      $COMPOSE run --rm \
        frontend-part \
        npm run serve "$@"
      cleanUp
    fi
  elif [ "$1" == "test" ];then
    install
    if [ $ABORT = false ];then
      shift 1
      $COMPOSE run --rm \
        backend-part \
        pytest "$@"
      cleanUp
    fi
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
    install
    if [ $ABORT = false ];then
      $COMPOSE "$@"
      cleanUp
    fi 
  fi
else
  install
  if [ $ABORT = false ];then
    $COMPOSE up
    cleanUp
  fi
fi
