#!/bin/bash
set -euo pipefail
COMPOSE="docker compose"
export LOC=${LOC:-dev}
UPFILE="docker-compose.yml"
ENVPATH=.deploy/env*

if [ "$LOC" == "ci" ];then
    UPFILE="docker-compose.ci.yml"
elif [ "$LOC" == "prod" ];then
    UPFILE="docker-compose.prod.yml"
elif [ "$LOC" != "dev" ];then
    echo "unsupported parameter for LOC, choose dev, ci or prod"
    exit
fi 

if [ $# -gt 0 ]
then
    if [ "$1" == "setup" ];then
        $COMPOSE -f .deploy/$UPFILE build frontend-part
        $COMPOSE -f .deploy/$UPFILE build backend-part
    elif [ "$1" == "start" ];then
        if [ "$LOC" == "dev" ];then
            docker network create proxy
        fi
            $COMPOSE -f .deploy/$UPFILE up -d
    elif [ "$1" == "exit" ];then
        $COMPOSE -f .deploy/$UPFILE down
        if [ "$LOC" == "dev" ];then
            docker network rm proxy
        fi
    elif [ "$1" == "clean" ];then
        docker container stop $(docker container ls -aq) && \
            docker system prune -af --volumes
    elif [ "$1" == "migrate" ];then
        $COMPOSE -f .deploy/$UPFILE exec -T \
            backend-part \
            python manage.py migrate
    elif [ "$1" == "test" ];then
        shift 1
        $COMPOSE -f .deploy/$UPFILE exec -T \
            backend-part \
            pytest "$@"
    elif [ "$1" == "wait" ];then
        if [ -f "$ENVPATH" ];then
            export $(cat "$ENVPATH" | xargs)
            if grep -Fq MYSQL_PORT "$ENVPATH" && grep -Fq MYSQL_HOST "$ENVPATH"
            then
                if [ -z "$MYSQL_PORT" ] && [ -z "$MYSQL_HOST" ];then
                    echo "environment variables unset in env file"
                else
                    $COMPOSE -f .deploy/$UPFILE exec -T \
                        backend-part \
                        bash -c "until nc -z -v -w30 vote-app-mysql 3306; do sleep 2; done;"
                fi
            fi
        fi
    fi
fi