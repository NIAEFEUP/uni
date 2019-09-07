FROM gableroux/flutter:v1.7.6

RUN mkdir -p /app

COPY ./app_feup/ /app

WORKDIR /app

RUN flutter pub get