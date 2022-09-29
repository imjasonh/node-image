# Dockerless builds for npm

This demonstrates a simple Node.js app that is built into a container image and pushed to a registry without needing Docker.

## Usage

Set the `DOCKER_REPO` env var to a Docker/OCI repository you have push access to.

```
export DOCKER_REPO=gcr.io/my-project/test
```

```
$ npm run image
...
gcr.io/my-project/test/node-image-test@sha256:cdef7514faa3efb8e71ad96e27da2592464e2673babdde095eb1ab68ad5ff200
```

You can `docker run` the image directly, with `--silent`:

```
$ docker run $(npm run --silent image)
...
Unable to find image 'gcr.io/my-project/test/node-image-test@sha256:cdef7514faa3efb8e71ad96e27da2592464e2673babdde095eb1ab68ad5ff200' locally
...
Status: Downloaded newer image for gcr.io/my-project/test/node-image-test@sha256:cdef7514faa3efb8e71ad96e27da2592464e2673babdde095eb1ab68ad5ff200
hello
```

By default the base image is `node:alpine`.
You can select a different base image with the `BASE` env var, e.g., `BASE=node:buster npm run image`

## Caveats

- ⚠️ This runs `npm install` in your developer environment -- not in a container -- and malicious build scripts in dependencies can wreck your environment! Vet your dependencies.

- This only supports `linux/amd64` for now. If this becomes a real thing I image it would support multi-arch builds fairly easily. Maybe even Windows?!
