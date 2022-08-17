#!/bin/bash
set -euo pipefail
COMPOSE="docker-compose"
export LOC=${LOC:-local}

function install() {
  if [ "$LOC" == "local" ];then
    docker network create proxy
    if [ ! -f docker-compose.yml ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
    fi
  fi
  if [ "$LOC" == "ci" ];then
    if [ ! -f docker-compose.yml ] && [ ! -f vote_app_backend/vote_app_backend/settings.py ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/settings.py vote_app_backend/vote_app_backend/settings.py || true
    fi
  fi
}

function cleanUp() {
  $COMPOSE down
  rm docker-compose.yml
  rm vote_app_backend/vote_app_backend/settings.py
}

if [ $# -gt 0 ]
then
#################Docker dependent command options, all run commands create new containers
  if [ "$LOC" == "local" ];then
    install
    if [ "$1" == "setup" ];then
      $COMPOSE build
    fi
    cleanUp
#################administrative command options
  elif [ "$LOC" == "op" ];then
    if [ "$1" == "clean" ];then
      docker container stop $(docker container ls -aq) && \
        docker system prune -af --volumes
    fi
#################execution in running Docker containers command options
  elif [ "$LOC" == "exec" ];then
    if [ -f docker-compose.yml ];then
      if [ "$1" == "migrate" ];then
        $COMPOSE exec -T \
          backend-part \
          python manage.py migrate
      elif [ "$1" == "test" ];then
        shift 1
        $COMPOSE exec -T \
          backend-part \
          pytest "$@"
      #shutdown app correctly
      elif [ "$1" == "exitci" ];then
        $COMPOSE down
        cleanUp
      elif [ "$1" == "exit" ];then
        $COMPOSE down
        docker network rm proxy
        cleanUp
      elif [ "$1" == "wait" ];then
        if [ -f .env ]; then
          export $(cat .env | xargs)
          if grep -Fq MYSQL_PORT .env && grep -Fq MYSQL_HOST .env
          then
            if [ -z "$MYSQL_PORT" ] && [ -z "$MYSQL_HOST" ];then
              echo "environment variables unset in .env file"
            else
              $COMPOSE exec -T \
                backend-part \
                bash -c "until nc -z -v -w30 vote-app-mysql 3306; do sleep 2; done;"
            fi
          fi
        fi
      else
        $COMPOSE exec -T "$@"
      fi
    fi
  fi
#start app correctly
elif [ "$LOC" == "local" ] || [ "$LOC" == "ci" ];then
  install
  $COMPOSE up -d
fi  