#!/bin/sh
set -e

yarn install --frozen-lockfile
./bin/vite dev

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"