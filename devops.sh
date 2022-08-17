#!/bin/bash
set -euo pipefail
COMPOSE="docker compose"
export LOC=${LOC:-local}


if [ $# -gt 0 ]
then
    if [ "$1" == "setup" ];then
        $COMPOSE build
    elif [ "$1" == "start" ];then
        if [ "$LOC" == "local" ];then
            docker network create proxy
            $COMPOSE -f docker-compose.yml up -d
        elif [ "$LOC" == "ci" ];then
            $COMPOSE -f docker-compose.ci.yml up -d
        fi
    elif [ "$1" == "exit" ];then
        if [ "$LOC" == "local" ];then
            $COMPOSE down
            docker network rm proxy
        elif [ "$LOC" == "ci" ];then
            $COMPOSE down
        fi
    elif [ "$1" == "clean" ];then
        docker container stop $(docker container ls -aq) && \
            docker system prune -af --volumes
    elif [ "$1" == "migrate" ];then
        $COMPOSE exec -T \
            backend-part \
            python manage.py migrate
    elif [ "$1" == "test" ];then
        shift 1
        $COMPOSE exec -T \
            backend-part \
            pytest "$@"
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
    fi
fi