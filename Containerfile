FROM dhi.io/bun:1-alpine3.22-dev AS builder
WORKDIR /app
COPY package.json ./
RUN bun install

FROM dhi.io/bun:1-alpine3.22
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY gen/ gen/
COPY demo_server.ts .
EXPOSE 50051
CMD ["bun", "run", "demo_server.ts"]
