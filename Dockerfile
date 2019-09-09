FROM gableroux/flutter:v1.7.6

WORKDIR /app

COPY ./app_feup/ .

RUN flutter pub get

CMD [ "bash", "-c" , "flutter analyze --no-pub --preamble . && flutter test"]