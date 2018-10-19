#!/bin/bash

TMPD=/tmp/$$.pspd

mkdir -p "$TMPD"

cd "$TMPD"

echo "Downloading package and its deps: $1" >&2
pip download "$1" &>/dev/null
ls -1 

rm -rf "$TMPD"

