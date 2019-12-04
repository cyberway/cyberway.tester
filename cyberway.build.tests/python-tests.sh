#!/bin/bash

set -euo pipefail

dir=$(dirname "$0")

BUILDER_IMAGETAG=${BUILDKITE_BRANCH:-master}

docker build -t cyberway/cyberway.build:${BUILDKITE_BRANCH} --build-arg branch=1165_separate_cyberway_tests --build-arg builder=${BUILDER_IMAGETAG} -f $dir/Docker/Dockerfile . 

docker stop keosd || true
docker stop nodeosd || true
docker stop mongo || true
docker rm keosd || true
docker rm nodeosd || true
docker rm mongo || true

IMAGETAG=${BUILDKITE_BRANCH:-master}

docker run --rm -ti cyberway/cyberway.build:$IMAGETAG  /bin/bash -c 'cd /opt/cyberway.build/ && ctest' 

exit $?
