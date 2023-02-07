#!/bin/sh
set -e

# Adapted from https://github.com/nodejs/docker-node/blob/main/19/alpine3.17/docker-entrypoint.sh 
# to substitute default amcat host

# Run command with node if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- node "$@"
fi

if [ -n "$amcat4_host" ]; then
  sed -i "s|http://localhost:5000|${amcat4_host}|g" pages/index.tsx
fi

exec "$@"
