#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

export $(grep -v '^#' .build-env | xargs)

RUST_UBUNTU_VERSIONS="${RUST_VERSION}-${UBUNTU_VERSION}"
NODEJS_RUST_UBUNTU_VERSIONS="${NODEJS_VERSION}-${RUST_VERSION}-${UBUNTU_VERSION}"


echo "[INFO] Removing ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"
docker rmi -f "${RUST_VERSION}-${UBUNTU_VERSION}-base-image" && \
echo "[INFO] DONE: removing ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"

echo "[INFO] Building ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"
docker build -t "${RUST_VERSION}-${UBUNTU_VERSION}-base-image" ./ubuntu-rust/. && \
echo "[INFO] DONE: building ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"

echo "[INFO] Removing ${RUST_VERSION}-${UBUNTU_VERSION} docker container"
docker rm -f "${RUST_VERSION}-${UBUNTU_VERSION}" && \
echo "[INFO] DONE: removing ${RUST_VERSION}-${UBUNTU_VERSION} container"

echo "[INFO] Running ${RUST_VERSION}-${UBUNTU_VERSION} docker container"
docker run --name  "${RUST_VERSION}-${UBUNTU_VERSION}"  "${RUST_VERSION}-${UBUNTU_VERSION}-base-image" && \
echo "[INFO] DONE: Finished running ${RUST_VERSION}-${UBUNTU_VERSION} docker container"

echo "[INFO] Removing ${RUST_VERSION}-${UBUNTU_VERSION} docker image"
docker rmi -f "${RUST_VERSION}-${UBUNTU_VERSION}" && \
echo "[INFO] DONE: removing ${RUST_VERSION}-${UBUNTU_VERSION} docker image"

echo "[INFO] Committing ${RUST_VERSION}-${UBUNTU_VERSION} docker container"
docker commit  "${RUST_VERSION}-${UBUNTU_VERSION}" "${RUST_VERSION}-${UBUNTU_VERSION}" && \
echo "[INFO] Done committing ${RUST_VERSION}-${UBUNTU_VERSION} docker container"


echo "--------------------------------------------"


echo "[INFO] Removing ${NODEJS_RUST_UBUNTU_VERSIONS}-base-image docker image"
docker rmi -f "${NODEJS_RUST_UBUNTU_VERSIONS}-base-image" && \
echo "[INFO] DONE: removing ${NODEJS_RUST_UBUNTU_VERSIONS}-base-image docker image"

echo "[INFO] Building ${NODEJS_RUST_UBUNTU_VERSIONS}-base-image docker image"
docker build --build-arg RUST_UBUNTU_VERSIONS="$RUST_UBUNTU_VERSIONS" -t "${NODEJS_RUST_UBUNTU_VERSIONS}-base-image" ./ubuntu-rust-nodejs/. && \
echo "[INFO] DONE: building ${NODEJS_RUST_UBUNTU_VERSIONS}-base-image docker image"

echo "[INFO] Removing $NODEJS_RUST_UBUNTU_VERSIONS docker container"
docker rm -f "$NODEJS_RUST_UBUNTU_VERSIONS" && \
echo "[INFO] DONE: removing $NODEJS_RUST_UBUNTU_VERSIONS container"

echo "[INFO] Running $NODEJS_RUST_UBUNTU_VERSIONS docker container"
docker run --name  "$NODEJS_RUST_UBUNTU_VERSIONS"  "$NODEJS_RUST_UBUNTU_VERSIONS-base-image" && \
echo "[INFO] DONE: Finished running $NODEJS_RUST_UBUNTU_VERSIONS docker container"

echo "[INFO] Removing ${NODEJS_RUST_UBUNTU_VERSIONS} docker image"
docker rmi -f "${NODEJS_RUST_UBUNTU_VERSIONS}" && \
echo "[INFO] DONE: removing ${NODEJS_RUST_UBUNTU_VERSIONS} docker image"

echo "[INFO] Committing $NODEJS_RUST_UBUNTU_VERSIONS docker container"
docker commit  "$NODEJS_RUST_UBUNTU_VERSIONS" "$NODEJS_RUST_UBUNTU_VERSIONS" && \
echo "[INFO] Done committing $NODEJS_RUST_UBUNTU_VERSIONS docker container"


echo "--------------------------------------------"



echo "[INFO] Removing ${SOLANA_VERSION}-base-image docker image"
docker rmi -f "${SOLANA_VERSION}-base-image" && \
echo "[INFO] DONE: removing ${SOLANA_VERSION}-base-image docker image"

echo "[INFO] Building ${SOLANA_VERSION}-base-image docker image"
docker build --build-arg NODEJS_RUST_UBUNTU_VERSIONS="$NODEJS_RUST_UBUNTU_VERSIONS" -t "${SOLANA_VERSION}-base-image" ./solana-ubuntu-rust-nodejs/. && \
echo "[INFO] DONE: building ${SOLANA_VERSION}-base-image docker image"

echo "[INFO] Removing ${SOLANA_VERSION} docker container"
docker rm -f "${SOLANA_VERSION}" && \
echo "[INFO] DONE: removing ${SOLANA_VERSION} container"

echo "[INFO] Running ${SOLANA_VERSION} docker container"
docker run --name  "${SOLANA_VERSION}"  "${SOLANA_VERSION}-base-image" && \
echo "[INFO] DONE: Finished running ${SOLANA_VERSION} docker container"

echo "[INFO] Removing ${SOLANA_VERSION} docker image"
docker rmi -f "${SOLANA_VERSION}" && \
echo "[INFO] DONE: removing ${SOLANA_VERSION} docker image"

echo "[INFO] Committing ${SOLANA_VERSION} docker container"
docker commit  "${SOLANA_VERSION}" "${SOLANA_VERSION}" && \
echo "[INFO] Done committing ${SOLANA_VERSION} docker container"


echo "[INFO] Cleaning up... "
docker rmi -f "${NODEJS_RUST_UBUNTU_VERSIONS}-base-image" && \
docker rmi -f "${SOLANA_VERSION}-base-image" && \
docker rm -f "${RUST_UBUNTU_VERSIONS}" && \
docker rm -f "${NODEJS_RUST_UBUNTU_VERSIONS}" && \
docker rm -f "${SOLANA_VERSION}" && \
echo "[INFO] DONE: Finished leaning up..."


echo "[INFO] DONE CREATE, RUN, COMMIT docker images"




