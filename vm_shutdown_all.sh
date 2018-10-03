#!/bin/bash
cd /usr/local/bin

virsh list | awk '{print $2;}' | grep -v "Name" | egrep -v '^$' | while read N; do
	set -x
	virsh shutdown "$N"
	set +x
	sleep 1
done

sleep 2

virsh list | awk '{print $2;}' | grep -v "Name" | egrep -v '^$' | while read N; do
	set -x
	virsh shutdown "$N"
	set +x
	sleep 2
done
