#! /bin/bash
COMPOSE="docker-compose"
COPIED=false
export LOC=${LOC:-local}
ABORT=false

function install() {
  #if file does not exist
  if [ ! -f docker-compose.yml ] && [ ! -f vue.config.js ];then
    if [ "$LOC" == "local" ] || [ "$LOC" == "stage" ] || [ "$LOC" == "ci" ];then
      cp .deploy/${LOC}/docker-compose.yml docker-compose.yml || true
      cp .deploy/${LOC}/vue.config.js frontend-ui/vue.config.js || true
      COPIED=true
    else
      echo "wrong execution folder specified, specify local, stage or ci"
      ABORT=true
    fi
  fi
}

function cleanUp() {
  if [ "$COPIED" = true ];then
    rm docker-compose.yml
    rm frontend-ui/vue.config.js
  fi
}

if [ $# -gt 0 ]
then
  if [ "$1" == "exit" ];then
    install
    if [ $ABORT = false ];then
      $COMPOSE down
      cleanUp
    fi
  elif [ "$1" == "runserver" ];then
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
