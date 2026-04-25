FROM dhi.io/python:3-alpine3.23-dev AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --target /deps

FROM dhi.io/python:3-alpine3.23
WORKDIR /app
COPY --from=build /deps /deps
COPY gen/ gen/
COPY demo_server.py .
ENV PYTHONPATH=/app/gen:/deps
ENTRYPOINT ["python", "demo_server.py"]
