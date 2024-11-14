FROM golang:1.23-alpine3.20 AS build

RUN apk add --no-cache git \
    && go install github.com/k1LoW/calver/cmd/calver@v0.7.3

FROM alpine:3.20

RUN apk add --no-cache bash dumb-init github-cli jq

COPY --from=build /go/bin/calver /usr/local/bin/calver
COPY entrypoint.sh /entrypoint.sh

RUN calver --version && gh --version

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint.sh"]
