FROM dhi.io/python:3-alpine3.23-dev AS build
WORKDIR /app
RUN apk add --no-cache git
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --target /deps

FROM dhi.io/python:3-alpine3.23
WORKDIR /app
COPY --from=build /deps /deps
COPY server.py .
EXPOSE 50051
ENV PYTHONPATH=/deps
ENTRYPOINT ["python", "server.py"]
