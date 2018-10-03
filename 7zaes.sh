#!/bin/bash

ITEM="$1"
PASSWD="$2"

usage () {
    echo "7zaes.sh item password"
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

7za a -p${PASSWD} -mhe+  "${ITEM}.7z" "${ITEM}"


