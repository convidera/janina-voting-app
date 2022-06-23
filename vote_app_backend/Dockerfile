FROM python:3-alpine as dev-stage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . /code
WORKDIR /code
RUN python -m pip install --upgrade pip
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev
RUN pip install -r requirements.txt
EXPOSE 8080 
CMD ["gunicorn", "vote_app_backend.wsgi:application", "--bind", "0.0.0.0:8000"]

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
CMD ["gunicorn" , "vote_app_backend.wsgi:application", "--workers", "3" "--bind", ":80"]