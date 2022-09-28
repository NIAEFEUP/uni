FROM cirrusci/flutter:3.3.2

WORKDIR /app

COPY ./app_feup/ .

RUN flutter pub get

CMD [ "sh", "-c" , "flutter analyze --no-pub --preamble . && flutter test"]
