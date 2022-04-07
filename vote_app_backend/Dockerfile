FROM python:3-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1



COPY . /code
WORKDIR /code


RUN python -m pip install --upgrade pip


RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev

RUN apk add py3-mysqlclient


RUN pip install -r requirements.txt

EXPOSE 8000