#!/bin/sh

set -eu

if [ $# -lt 1 ]
then
echo "Usage: $0 { version }" >&2
exit 1
fi

curl -sSL https://dl.k8s.io/v$1/kubernetes-client-linux-arm64.tar.gz |\
    tar -xz kubernetes/client/bin/kubectl --to-stdout
