# stage 1 Build qgb binary
FROM --platform=$BUILDPLATFORM docker.io/golang:1.21.1-alpine3.18 as builder
RUN apk update && apk --no-cache add make gcc musl-dev git bash

COPY . /orchestrator-relayer
WORKDIR /orchestrator-relayer
RUN make build

# final image
#FROM --platform=$BUILDPLATFORM docker.io/alpine:3.18.3
FROM --platform=$BUILDPLATFORM ghcr.io/celestiaorg/celestia-app:v1.0.0-rc15
#FROM --platform=$BUILDPLATFORM ubuntu:22.04

# ARG UID=10001
# ARG USER_NAME=celestia

# ENV CELESTIA_HOME=/home/${USER_NAME}

# # hadolint ignore=DL3018
# RUN apk update && apk add --no-cache \
#         bash \
#         curl \
#         jq \
#     # Creates a user with $UID and $GID=$UID
#     && adduser ${USER_NAME} \
#         -D \
#         -g ${USER_NAME} \
#         -h ${CELESTIA_HOME} \
#         -s /sbin/nologin \
# #         -u ${UID}
# RUN adduser ${USER_NAME} \
#         -D \
#         -g ${USER_NAME} \
#         -h ${CELESTIA_HOME} \
#         -s /sbin/nologin \
#         -u ${UID}
# WORKDIR /orchestrator-relayer

# RUN apt update && apt install -y make curl bash git wget &&\
#     adduser --disabled-password --gecos "" --uid ${UID} --home ${CELESTIA_HOME} ${USER_NAME}

# RUN wget https://go.dev/dl/go1.21.1.linux-amd64.tar.gz

# RUN wget "https://golang.org/dl/go1.21.1.linux-amd64.tar.gz" ;\
#     rm -rf /usr/local/go ;\
#     tar -C /usr/local -xzf "go1.21.1.linux-amd64.tar.gz" ;\
#     rm go1.21.1.linux-amd64.tar.gz

# ENV PATH="/usr/local/go/bin:${PATH}"

# COPY . /orchestrator-relayer

# RUN make build
# RUN cp build/qgb /bin/qgb

COPY --from=builder /orchestrator-relayer/build/qgb /bin/qgb
COPY --chown=${USER_NAME}:${USER_NAME} docker/entrypoint.sh /opt/entrypoint.sh
USER root

#USER ${USER_NAME}

# p2p port
EXPOSE 30000
#CMD [ "/bin/qgb" ]
#CMD [ "/bin/bash", "/opt/entrypoint.sh" ]
#ENTRYPOINT [ "/bin/bash", "/opt/entrypoint.sh" ]
