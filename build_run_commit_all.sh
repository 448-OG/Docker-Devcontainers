#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -euo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO"' ERR

export $(grep -v '^#' .build-env | xargs)

RUST_UBUNTU_VERSIONS="${RUST_VERSION}-${UBUNTU_VERSION}"
NODEJS_RUST_UBUNTU_VERSIONS="${NODEJS_VERSION}-${RUST_VERSION}-${UBUNTU_VERSION}"


echo "[INFO] Removing all docker images, volumes, networks and containers"
docker system prune -a --volumes -f
echo "[INFO] DONE: removing  all docker images, volumes, networks and containers"

echo "[INFO] Removing ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"
docker rmi -f "${RUST_VERSION}-${UBUNTU_VERSION}-base-image"
echo "[INFO] DONE: removing ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"

echo "[INFO] Building ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"
docker build -t "${RUST_VERSION}-${UBUNTU_VERSION}-base-image" ./ubuntu-rust/.
echo "[INFO] DONE: building ${RUST_VERSION}-${UBUNTU_VERSION}-base-image docker image"

echo "[INFO] Removing ${RUST_VERSION}-${UBUNTU_VERSION} docker container"
docker rm -f "${RUST_VERSION}-${UBUNTU_VERSION}"
echo "[INFO] DONE: removing ${RUST_VERSION}-${UBUNTU_VERSION} container"

echo "[INFO] Running ${RUST_VERSION}-${UBUNTU_VERSION} docker container"
docker run --name "${RUST_VERSION}-${UBUNTU_VERSION}" "${RUST_VERSION}-${UBUNTU_VERSION}-base-image"
echo "[INFO] DONE: Finished running ${RUST_VERSION}-${UBUNTU_VERSION} docker container"

echo "[INFO] Removing ${RUST_VERSION}-${UBUNTU_VERSION} docker image"
docker rmi -f "${RUST_VERSION}-${UBUNTU_VERSION}"
echo "[INFO] DONE: removing ${RUST_VERSION}-${UBUNTU_VERSION} docker image"

echo "[INFO] Committing ${RUST_VERSION}-${UBUNTU_VERSION} docker container"
docker commit "${RUST_VERSION}-${UBUNTU_VERSION}" "${RUST_VERSION}-${UBUNTU_VERSION}"
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



echo "[INFO] Removing ${SURFPOOL_VERSION}-base-image docker image"
docker rmi -f "${SURFPOOL_VERSION}-base-image" && \
echo "[INFO] DONE: removing ${SURFPOOL_VERSION}-base-image docker image"

echo "[INFO] Building ${SURFPOOL_VERSION}-base-image docker image"
docker build --build-arg NODEJS_RUST_UBUNTU_VERSIONS="$NODEJS_RUST_UBUNTU_VERSIONS" -t "${SURFPOOL_VERSION}-base-image" ./solana-ubuntu-rust-nodejs/. && \
echo "[INFO] DONE: building ${SURFPOOL_VERSION}-base-image docker image"

echo "[INFO] Removing ${SURFPOOL_VERSION} docker container"
docker rm -f "${SURFPOOL_VERSION}" && \
echo "[INFO] DONE: removing ${SURFPOOL_VERSION} container"

echo "[INFO] Running ${SURFPOOL_VERSION} docker container"
docker run --name  "${SURFPOOL_VERSION}"  "${SURFPOOL_VERSION}-base-image" && \
echo "[INFO] DONE: Finished running ${SURFPOOL_VERSION} docker container"

echo "[INFO] Removing ${SURFPOOL_VERSION} docker image"
docker rmi -f "${SURFPOOL_VERSION}" && \
echo "[INFO] DONE: removing ${SURFPOOL_VERSION} docker image"

echo "[INFO] Committing ${SURFPOOL_VERSION} docker container"
docker commit  "${SURFPOOL_VERSION}" "${SURFPOOL_VERSION}" && \
echo "[INFO] Done committing ${SURFPOOL_VERSION} docker container"


echo "[INFO] Cleaning up... "
docker rmi -f "${NODEJS_RUST_UBUNTU_VERSIONS}-base-image" && \
docker rmi -f "${SURFPOOL_VERSION}-base-image" && \
docker rm -f "${RUST_UBUNTU_VERSIONS}" && \
docker rm -f "${NODEJS_RUST_UBUNTU_VERSIONS}" && \
docker rm -f "${SURFPOOL_VERSION}" && \
echo "[INFO] DONE: Finished leaning up..."


echo "[INFO] DONE CREATE, RUN, COMMIT docker images"