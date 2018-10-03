#!/bin/bash

THRESHOLD=30

EXC=/tmp/$$.du


mount -t ext4 | awk '{print $3;}' | while read FS; do
	USED=$(df -h "$FS" | tail -n  1 | awk '{print $5;}' | tr -d '%')	
	if [ $USED -gt $THRESHOLD ]; then
		echo "Filesystem $FS exceeded maximum disk space allowed, current du: ${USED}%" >> "$EXC"
	fi
done

if [ -f "$EXC" ]; then
	cat "$EXC"
	swaks --to mrkafk@gmail.com --from logs@host.name --auth --auth-user=logs --auth-password=`cat /etc/local/df_cred.txt` --server mailserver --header "Subject: Disk usage high on host `hostname`" --body "`cat $EXC`"
	rm -f "$EXC"
fi



