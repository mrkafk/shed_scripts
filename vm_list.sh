#!/bin/bash

virsh list --all | tail -n +3 | awk '{print $2;}' | while read N; do
	if [ -n "$N" ]; then
		echo $N
        fi
done
