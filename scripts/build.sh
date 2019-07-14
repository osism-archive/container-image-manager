#!/usr/bin/env bash
set -x

# DO NOT EDIT THIS FILE BY HAND -- FILE IS SYNCHRONIZED REGULARLY

# Available environment variables
#
# BUILD_OPTS
# REPOSITORY
# VERSION
# VERSION_AWX
# RELEASE_OPENSTACK
# RELEASE_LUMINOUS

# Set default values

BUILD_OPTS=${BUILD_OPTS:-}
HASH_REPOSITORY=$(git rev-parse --short HEAD)

# https://github.com/jenkinsci/docker/blob/master/update-official-library.sh
version-from-dockerfile() {
    grep VERSION: Dockerfile | sed -e 's/.*:-\(.*\)}/\1/'
}

if [[ -z $VERSION ]]; then
    VERSION=$(version-from-dockerfile)
fi

docker build \
    --build-arg "VERSION=$VERSION" \
    --build-arg "VERSION_AWX=$VERSION_AWX" \
    --build-arg "RELEASE_CEPH=$RELEASE_CEPH" \
    --build-arg "RELEASE_OPENSTACK=$RELEASE_OPENSTACK" \
    --label "io.osism.${REPOSITORY#osism/}=$HASH_REPOSITORY" \
    --tag "$REPOSITORY:$VERSION" \
    --squash \
    $BUILD_OPTS .