#!/usr/bin/env bash
set -e
source /build/buildconfig
set -x

# Install bird and bird6
apk add --no-cache bird bird6

# Create the config directory for confd
mkdir config
