FROM dhi.io/ruby:4-alpine3.23-dev AS build
WORKDIR /app
COPY Gemfile .
RUN bundle install
COPY lib/ lib/
COPY demo_server.rb .

FROM dhi.io/ruby:4-alpine3.23
WORKDIR /app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app/lib lib/
COPY --from=build /app/demo_server.rb .
EXPOSE 50051
CMD ["ruby", "demo_server.rb"]
