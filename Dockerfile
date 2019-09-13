FROM gableroux/flutter:v1.7.6

WORKDIR /app

COPY ./app_feup/ .

RUN flutter pub get

CMD ["sh", "test.sh"]
