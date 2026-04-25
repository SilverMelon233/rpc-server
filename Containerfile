FROM dhi.io/ruby:4-alpine3.23-dev AS build
RUN apk add --no-cache git
WORKDIR /app
COPY Gemfile .
RUN bundle install
COPY server.rb .

FROM dhi.io/ruby:4-alpine3.23
WORKDIR /app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app/server.rb .
EXPOSE 50051
CMD ["ruby", "server.rb"]
