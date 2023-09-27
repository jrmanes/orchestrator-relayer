# stage 1 Build qgb binary
FROM golang:1.21.1-alpine as builder
RUN apk update && apk --no-cache add make gcc musl-dev git
COPY . /orchestrator-relayer
WORKDIR /orchestrator-relayer
RUN make build

# final image
FROM ghcr.io/celestiaorg/celestia-app:v1.0.0-rc15

USER root

# hadolint ignore=DL3018
RUN apk update && apk --no-cache add bash jq coreutils curl

COPY --from=builder /orchestrator-relayer/build/qgb /bin/qgb

USER celestia

# p2p port
EXPOSE 30000

CMD [ "/bin/qgb" ]