#!/usr/bin/env bash

set -euo pipefail

# TODO: allow setting platform(s)
# - for multi-arch, probably need something like https://github.com/google/go-containerregistry/issues/1456

BASE=${BASE:-node:alpine}

# TODO
IMAGE=${DOCKER_REPO:-gcr.io/jason-chainguard-public}
APP=$(cat package.json | jq -r .name)

>&2 echo "Pushing to ${IMAGE}/${APP}"

# Prevent npm output from going to stdout.
npm install --omit=dev 1>&2

MAIN=$(cat package.json | jq -r .main)
MAIN=${MAIN:-server.js}

crane mutate $(
  crane append -f <(tar -f - -c ./) -t ${IMAGE}/${APP} -b ${BASE}
) --entrypoint=node,${MAIN}
