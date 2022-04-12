FROM python:3-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1



COPY . /code
WORKDIR /code


RUN python -m pip install --upgrade pip


RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev


RUN pip install -r requirements.txt

EXPOSE 8000

VOLUME ["/code/vote_app_backend/mysqldata"]