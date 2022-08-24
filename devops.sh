#!/bin/bash
set -euo pipefail
COMPOSE="docker compose"
export LOC=${LOC:-dev}
upfile=docker-compose.yml

if [ "$LOC" == "ci" ];then
    upfile=docker-compose.ci.yml
elif [ "$LOC" == "prod" ];then
    upfile=docker-compose.prod.yml
elif [ "$LOC" != "dev" ];then
    echo "unsupported parameter for LOC, choose dev, ci or prod"
    exit
fi 

if [ $# -gt 0 ]
then
    if [ "$1" == "setup" ];then
        $COMPOSE -f "${upfile}" build frontend-part
        $COMPOSE -f "${upfile}" build backend-part
    elif [ "$1" == "start" ];then
        if [ "$LOC" == "dev" ];then
            docker network create proxy
        fi
            $COMPOSE -f "${upfile}" up -d
    elif [ "$1" == "exit" ];then
        $COMPOSE -f "${upfile}" down
        if [ "$LOC" == "dev" ];then
            docker network rm proxy
        fi
    elif [ "$1" == "clean" ];then
        docker container stop $(docker container ls -aq) && \
            docker system prune -af --volumes
    elif [ "$1" == "migrate" ];then
        $COMPOSE -f "${upfile}" exec -T \
            backend-part \
            python manage.py migrate
    elif [ "$1" == "test" ];then
        shift 1
        $COMPOSE -f "${upfile}" exec -T \
            backend-part \
            pytest "$@"
    elif [ "$1" == "wait" ];then
        if [ -f .env ];then
            export $(cat .env | xargs)
            if grep -Fq MYSQL_PORT .env && grep -Fq MYSQL_HOST .env
            then
                if [ -z "$MYSQL_PORT" ] && [ -z "$MYSQL_HOST" ];then
                    echo "environment variables unset in env file"
                else
                    $COMPOSE -f "${upfile}" exec -T \
                        backend-part \
                        bash -c "until nc -z -v -w30 vote-app-mysql 3306; do sleep 2; done;"
                fi
            fi
        fi
    fi
fi