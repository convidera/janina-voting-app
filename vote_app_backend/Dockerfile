FROM python:3-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY . /code
WORKDIR /code


RUN python -m pip install --upgrade pip

RUN apk update
RUN apk add py3-mysqlclient


RUN pip install -r requirements.txt

EXPOSE 8000