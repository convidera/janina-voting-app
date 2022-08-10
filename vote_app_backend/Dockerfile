FROM python:3-alpine as dev-stage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . /code
WORKDIR /code
RUN python -m pip install --upgrade pip
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev 
RUN apk add --no-cache netcat-openbsd
# RUN apt add musl \
#     && apt add libintl \
#     && apt add libffi busybox zlib \
#     && apt add glib \
#     && apt add netcat-openbsd
RUN pip install -r requirements.txt
EXPOSE 8000 

FROM python:3-alpine as prod-stage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . /code
WORKDIR /code
RUN python -m pip install --upgrade pip
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev
RUN pip install -r requirements.txt
EXPOSE 80 