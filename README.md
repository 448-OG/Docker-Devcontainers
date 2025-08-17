## Reusable docker containers with latest builds for Rust
Docker configurations fdr more recent packages that can be used when devcontainer packages are outdated. The target for this is Rust toolchain.

The docker image for nodejs is based on the container for Rust

## NOTE: Move to the working DIR for the container you want to build

## Common Commands
### List docker images
```sh
docker images
```
### Remove a docker image
```sh
dockers rmi <image name> # Use `-f` to force remove an image that has a container attached to it
```
### List docker container
```sh
docker ps -a # remove `-a` to list running containers only
```
### Remove a docker container
```sh
docker rm <container ID> # or use `<container name>` in place of `<container ID>`
```

## Create a Rust docker image
```sh
cd ubuntu-rust

docker build -t ubuntu25.04-rust-base-image .
```

## Create the Rust docker container
```sh
docker run --name rust ubuntu25.04-rust-base-image
```

## Commit the Rust docker container (will be reused to create Nodejs + Rust container)
```sh
docker commit rust ubuntu25.04-rust
```

## Create the Nodejs + Rust docker image
```sh
cd ubuntu-rust-nodejs

docker build -t ubuntu25.04-rust-nodejs-base-image .
```

## Create the Nodejs + Rust docker container
```sh
docker run --name nodejs ubuntu25.04-rust-nodejs-base-image
```

## Commit the Nodejs + Rust docker container
```sh
docker commit nodejs ubuntu25.04-rust-nodejs
```

## LICENSE
Apache-2.0 OR MIT