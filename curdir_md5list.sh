#!/bin/bash -x



LISTNAME="/tmp/`echo $PWD | tr '/' '_'`"
cat /dev/null > $LISTNAME

find . -type f | while read x; do
	md5sum "$x" >> "$LISTNAME"
done

echo $LISTNAME

