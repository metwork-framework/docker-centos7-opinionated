#!/bin/bash

#set -eu
set -x

docker pull metwork/centos7-opinionated:master
HASH_BEFORE=`docker images -q metwork/centos7-opinionated:master`
docker build -t metwork/centos7-opinionated:master -t metwork/centos7-opinionated:latest .
HASH_AFTER=`docker images -q metwork/centos7-opinionated:master`
if [ "${HASH_BEFORE}" != "${HASH_AFTER}" ]; then
    docker push metwork/centos7-opinionated:master
    docker push metwork/centos7-opinionated:latest
fi
