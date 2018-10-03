#!/bin/bash

ITEM="$1"
PASSWD="$2"

usage () {
    echo "txzaes.sh item password"
}

if [ -z "$ITEM" ]; then
    echo "Specify file/folder for decryption as first arg."
    exit 1
fi

if [ -z "$PASSWD" ]; then
    echo "Specify password for decryption as second arg."
    exit 1
fi

set -x

openssl aes-256-cbc -salt -d -in "$ITEM" -out "${ITEM}.txz" -k "$PASSWD"

tar xf "${ITEM}.txz"

set +x

rm -f "${ITEM}.txz"
