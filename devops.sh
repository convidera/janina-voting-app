#! /bin/bash -x
ENVPATH=./.env

COMPOSE="docker-compose"
USERENV="GITHUB_USER"
TOKENENV="GITHUB_TOKEN"

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
  elif [ "$1" == "pull" ];then
    if test -f "$ENVPATH"; then
      if grep -Fxq "$USERENV" .env; then 
        echo "true"
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
