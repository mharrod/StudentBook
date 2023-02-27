FROM python:3.10-slim AS build-env

COPY . /app

WORKDIR /app

RUN pip install --no-cache-dir --upgrade -r requirements.txt && cp $(which uvicorn) /app

FROM gcr.io/distroless/python3


COPY --from=build-env /app /app
COPY --from=build-env /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
ENV PYTHONPATH=/usr/local/lib/python3.10/site-packages

WORKDIR /app

CMD ["./uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8090"]