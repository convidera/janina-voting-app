FROM python:3-alpine as dev-stage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . /vote_app_backend
WORKDIR /vote_app_backend
RUN python -m pip install --upgrade pip
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev 
RUN apk add --no-cache bash netcat-openbsd 
RUN pip install -r requirements.txt
EXPOSE 8000 

FROM python:3-alpine as prod-stage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . /vote_app_backend
WORKDIR /vote_app_backend
RUN python -m pip install --upgrade pip
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev
RUN pip install -r requirements.txt
EXPOSE 80 