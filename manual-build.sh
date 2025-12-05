#!/bin/sh

# Build multi-arch image
# NOTE: RUN commands need to run on the real architecture, so borrowing the arm64 built images from a self-hosted build pipeline
# TODO: Automate more if this needs to be re-build frequently

podman manifest create  docker.io/aimmac23/conan-server

podman build -t  aimmac23/conan-server:latest-amd64 --layers --platform linux/amd64  .

podman manifest add docker.io/aimmac23/conan-server aimmac23/conan-server:latest-amd64
# From self-hosted Forgejo instance
podman manifest add docker.io/aimmac23/conan-server docker.aimmac23.com/aim/conan-server:latest


#podman manifest push docker.io/aimmac23/conan-server
