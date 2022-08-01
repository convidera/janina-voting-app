#!/bin/bash
set -euo pipefail
COMPOSE="docker-compose"
export LOC=${LOC:-local}

function install() {
  if [ "$LOC" == "local" ];then
    docker network create proxy
    if [ ! -f docker-compose.yml ] && [ ! -f frontend-ui/vue.config.js ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/vue.config.js frontend-ui/vue.config.js || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
    fi
  fi
  if [ "$LOC" == "ci" ];then
    if [ ! -f docker-compose.yml ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
    fi
  fi
  if [ "$LOC" == "stage" ];then
    if [ ! -f docker-compose.yml ] && [ ! -f frontend-ui/vue.config.js ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/vue.config.js frontend-ui/vue.config.js || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
    fi
  fi
}

function cleanUp() {
  $COMPOSE down
  rm docker-compose.yml
  rm vote_app_backend/vote_app_backend/settings.py
  if [ -f frontend-ui/vue.config.js ];then
    rm frontend-ui/vue.config.js
  fi
  if [ "$LOC" == "local" ];then
    docker network rm proxy
  fi
}

if [ $# -gt 0 ]
then
  if [ "$LOC" == "local" ] || [ "$LOC" == "ci" ] || [ "$LOC" == "stage" ];then
    install
    if [ "$1" == "migrate" ];then
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
    elif [ "$1" == "test" ];then
      shift 1
      $COMPOSE run --rm \
        backend-part \
        pytest "$@"
    else
      $COMPOSE "$@"
    fi
    cleanUp
  else [ "$LOC" == "op" ];then
    if [ "$1" == "push" ];then 
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
    fi
  fi
else
  if [ "$LOC" == "local" ];then
    install
    $COMPOSE up
    cleanUp
  fi
fi
