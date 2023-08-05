#!/bin/bash

PREFIX=abegorov

set -ex

if [[ ! -d "$1" ]]; then
    echo USAGE: $0 dir
    exit 1
fi

apt update --quiet
apt install --quiet --yes docker.io

docker stop "$1"
docker rm "$1"
docker rmi "$PREFIX/$1"

pushd "$1"
git pull
docker build --tag "$PREFIX/$1" "$1"
docker run --detach --publish 80:8080 --name "$1" "$PREFIX/$1"
popd
