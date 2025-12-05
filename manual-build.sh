#!/bin/sh

# Manual build image command
# TODO: Setup Github actions if this gets used enough

podman build -t aimmac23/conan-server:latest --layers .

