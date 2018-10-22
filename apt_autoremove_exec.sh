#!/bin/bash


if [ "$1" != "confirm" ]; then
    exit 1
fi

TMPF=/tmp/apt_autoremove.txt

apt-get -y autoremove &> "$TMPF"

cat "$TMPF"

