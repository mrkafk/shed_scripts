#!/bin/bash


if [ "$1" != "confirm" ]; then
    exit 1
fi

TMPF=/tmp/apt_upgr.txt

apt-get -y upgrade &> "$TMPF"

cat "$TMPF"

