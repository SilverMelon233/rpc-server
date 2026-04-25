FROM dhi.io/dart:3-alpine3.22-dev AS build
WORKDIR /app
COPY pubspec.yaml .
RUN dart pub get
COPY bin/ bin/
RUN dart compile exe bin/server.dart -o /app/server

FROM dhi.io/alpine-base:3.23
COPY --from=build /app/server /usr/local/bin/server
EXPOSE 50051
CMD ["/usr/local/bin/server"]
