FROM cirrusci/flutter:v1.12.13-hotfix.8-web

WORKDIR /app

COPY ./app_feup/ .

RUN sudo chown -R cirrus:cirrus /app

RUN flutter pub get

CMD [ "sh", "-c" , "flutter analyze --no-pub --preamble . && flutter test"]
