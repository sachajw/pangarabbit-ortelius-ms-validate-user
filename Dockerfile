FROM cgr.dev/chainguard/python:latest-dev AS builder
COPY . /app
RUN cd /app && pip install -r requirements.txt

FROM docker://cgr.dev/chainguard/python:3.11.2@sha256:7a0724c1aa6d9a53b6719639a20fafdfe431ebe84fe0159519119c2b337ae455
ENV DB_HOST localhost
ENV DB_NAME postgres
ENV DB_USER postgres
ENV DB_PASS postgres
ENV DB_PORT 5432

COPY --from=builder /app /app
COPY --from=builder /home/nonroot/.local /home/nonroot/.local

WORKDIR /app

EXPOSE 8080
ENV PATH=$PATH:/home/nonroot/.local/bin

ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
