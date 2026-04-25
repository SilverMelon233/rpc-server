FROM dhi.io/golang:1-alpine3.23-dev AS build
WORKDIR /src
COPY go.mod ./
COPY server.go ./
RUN GOFLAGS=-mod=mod GOPROXY=direct go get github.com/SilverMelon233/rpc-stub/golang@main && \
    GOFLAGS=-mod=mod GOPROXY=direct go build -o /server .

FROM dhi.io/alpine-base:3.23
COPY --from=build /server /server
EXPOSE 50051
ENTRYPOINT ["/server"]
