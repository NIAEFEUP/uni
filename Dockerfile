FROM cirrusci/flutter:2.0.1

WORKDIR /app

COPY ./app_feup/ .

RUN flutter pub get

CMD [ "sh", "-c" , "flutter analyze --no-pub --preamble . && flutter test"]
