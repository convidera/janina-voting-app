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
}

function waitForDBConnection() {
  if [ -f .env-ci ]; then
    export $(cat .env | xargs)
    if grep -Fq MYSQL_PORT .env-ci && grep -Fq MYSQL_HOST .env-ci
    then
      if [ -z "$MYSQL_PORT" ] && [ -z "$MYSQL_HOST" ];then
        echo "environment variables unset in .env file"
      else
        echo "Waiting for database connection ..."
        until nc -z -v -w30 $MYSQL_HOST $MYSQL_PORT
        do
          echo "."
          sleep 2
        done
      fi
    fi 
  fi
}

if [ $# -gt 0 ]
then
#################docker-compose dependent command options
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
    elif [ "$1" == "setup" ];then
      $COMPOSE build
    fi
    cleanUp
#################docker-compose independent command options
  elif [ "$LOC" == "op" ];then
    if [ "$1" == "push" ];then 
      git add *
      git commit -m "$2"
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
    elif [ "$1" == "clean" ];then
      docker container stop $(docker container ls -aq) && \
        docker system prune -af --volumes
    fi
#################running containers command options
  elif [ "$LOC" == "exec" ];then
    if [ -f docker-compose.yml ];then
      if [ "$1" == "migrate" ];then
        #-T disable pseudo-TTY allocation.
        $COMPOSE exec -T \
          backend-part \
          python manage.py migrate
      elif [ "$1" == "test" ];then
        shift 1
        $COMPOSE exec -T \
          backend-part \
          pytest "$@"
      #shutdown app correctly ci, stage
      elif [ "$1" == "exit" ];then
        $COMPOSE down
        cleanUp
      #shutdown app correctly local
      elif [ "$1" == "exitlocal" ];then
        $COMPOSE down
        docker network rm proxy
        cleanUp
      elif [ "$1" == "waitdb" ];then
        $COMPOSE exec -T \
          backend-part \
          waitForDBConnection
      else
        $COMPOSE exec -T "$@"
      fi
    fi
  fi
#start app correctly
elif [ "$LOC" == "local" ] || [ "$LOC" == "ci" ] || [ "$LOC" == "stage" ];then
  install
  $COMPOSE up -d
fi