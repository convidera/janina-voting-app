# progrlang-vote-app

## Project setup
```
Build single image:
===================

docker build -t alonimacaroni/vote-frontend .

docker run -it -p 8080:8080 --rm --name frontend-part alonimacaroni/vote-frontend
