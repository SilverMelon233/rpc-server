FROM dhi.io/dotnet:10-sdk-alpine3.23 AS build
RUN apk add --no-cache git
WORKDIR /src
RUN git clone --branch csharp --depth 1 https://github.com/SilverMelon233/rpc-stub /tmp/rpc-stub && \
    dotnet pack /tmp/rpc-stub/DemoStub.csproj -o /tmp/nuget-feed
COPY server.csproj .
COPY *.cs ./
RUN dotnet nuget add source /tmp/nuget-feed --name local && \
    dotnet publish -c Release -o /app

FROM dhi.io/dotnet:10-aspnet-alpine3.23
WORKDIR /app
COPY --from=build /app .
EXPOSE 50051
ENTRYPOINT ["dotnet", "Server.dll"]
