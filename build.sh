#!/bin/bash

PREFIX=abegorov

set -ex

if [[ ! -d "$1" ]]; then
    echo USAGE: $0 dir
    exit 1
fi

apt update --quiet
apt install --quiet --yes docker.io

if [[ -n "$(docker ps --quiet --filter name="$1")" ]]; then
    docker stop "$1"
fi
if [[ -n "$(docker ps --all --quiet --filter name="$1")" ]]; then
    docker rm "$1"
fi
if [[ -n "$(docker images --quiet "$1")" ]]; then
    docker rmi "$PREFIX/$1"
fi

pushd "$1"
git pull
docker build --tag "$PREFIX/$1" .
docker run --detach --publish 80:8080 --name "$1" "$PREFIX/$1"
popd
