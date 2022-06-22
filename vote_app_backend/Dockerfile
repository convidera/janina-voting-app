# build stage
FROM python:3-alpine as build-stage
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY . /code
WORKDIR /code
RUN python -m pip install --upgrade pip
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev
RUN pip install -r requirements.txt

# development stage
FROM python:3-alpine as dev-stage
COPY --from=build-stage /code /code
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "vote_app_backend.wsgi:application"]

# production stage
FROM python:3-alpine as prod-stage
COPY --from=build-stage /code /code
#RUN python code/manage.py collectstatic
EXPOSE 8000
CMD ["gunicorn", "--bind", ":8000", "--workers", "3", "vote_app_backend.wsgi:application"]