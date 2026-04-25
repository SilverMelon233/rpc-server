FROM dhi.io/dart:3-alpine3.22-dev AS build
WORKDIR /app
COPY pubspec.yaml .
RUN dart pub get
COPY bin/ bin/
RUN dart compile exe bin/demo_server.dart -o /app/demo_server

FROM dhi.io/alpine-base:3.23
COPY --from=build /app/demo_server /usr/local/bin/demo-server
EXPOSE 50051
CMD ["/usr/local/bin/demo-server"]
