#!/bin/bash
set -euo pipefail
COMPOSE="docker compose"
export LOC=${LOC:-dev}
upfile=docker-compose.yml
envpath=.deploy/.env

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
        $COMPOSE -f .deploy/"${upfile}" build frontend-part
        $COMPOSE -f .deploy/"${upfile}" build backend-part
    elif [ "$1" == "start" ];then
        if [ "$LOC" == "dev" ];then
            docker network create proxy
        fi
            $COMPOSE -f .deploy/"${upfile}" up
    elif [ "$1" == "exit" ];then
        $COMPOSE -f .deploy/"${upfile}" down
        if [ "$LOC" == "dev" ];then
            docker network rm proxy
        fi
    elif [ "$1" == "clean" ];then
        docker container stop $(docker container ls -aq) && \
            docker system prune -af --volumes
    elif [ "$1" == "migrate" ];then
        $COMPOSE -f .deploy/"${upfile}" exec -T \
            backend-part \
            python manage.py migrate
    elif [ "$1" == "test" ];then
        shift 1
        $COMPOSE -f .deploy/"${upfile}" exec -T \
            backend-part \
            pytest "$@"
    elif [ "$1" == "wait" ];then
        if [ -f "${envpath}" ];then
            export $(cat "${envpath}" | xargs)
            if grep -Fq MYSQL_PORT "${envpath}" && grep -Fq MYSQL_HOST "${envpath}"
            then
                if [ -z "$MYSQL_PORT" ] && [ -z "$MYSQL_HOST" ];then
                    echo "environment variables unset in env file"
                else
                    $COMPOSE -f .deploy/"${upfile}" exec -T \
                        backend-part \
                        bash -c "until nc -z -v -w30 vote-app-mysql 3306; do sleep 2; done;"
                fi
            fi
        fi
    fi
fi