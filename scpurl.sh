#!/bin/bash

echo "$USER@`hostname --fqdn`:`pwd`"

ip a | grep -w inet | grep -v 127.0.0.1 | awk '{print $2;}' | awk -F/ '{print $1;}' | while read IPADDR; do
    echo "$USER@$IPADDR:`pwd`"
done
