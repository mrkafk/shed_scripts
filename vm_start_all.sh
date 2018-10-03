#!/bin/bash
cd /usr/local/bin

./vm_list.sh | while read N; do
	if [ -n "$N" ]; then
		echo $N
		virsh start "$N"
        fi
done
