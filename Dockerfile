FROM alpine:3.10

RUN apk add --no-cache \
    bash=5.0.0-r0 \
    curl=7.65.1-r0 \
    jq=1.6-r0

ENTRYPOINT []

WORKDIR /workspace

COPY . /workspace/