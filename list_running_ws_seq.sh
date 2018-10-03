#!/bin/bash

function check_running () {
	HOST="$1"
	S=`ping -c 1 $HOST | grep transmitted | grep -v "0 received"`
	if [ -n "$S" ]; then
		echo "$HOST is alive"
	fi
}

list_ws.sh | while read x; do
	check_running "$x"
done

