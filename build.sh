#!/bin/bash

PREFIX=abegorov

set -ex

if [[ ! -d "$1" ]]; then
    echo USAGE: $0 dir
    exit 1
fi

if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
    apt update --quiet
    apt install --quiet --yes ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

apt update --quiet
apt install --quiet --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

for dir in *; do
    if [[ -d "$dir" ]]; then
        if [[ -n "$(docker ps --quiet --filter name="$dir")" ]]; then
            docker stop "$dir"
        fi
    fi
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
