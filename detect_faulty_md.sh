#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


"$SCRIPTDIR"/detect_faulty_md.py
if [ $? -ne 0 ]; then
	TMP=/tmp/$$.txt
	cat /proc/mdstat > $TMP
	echo >> $TMP
	echo "Disk serial numbers:" >> $TMP
	"$SCRIPTDIR"/disk_serial_no.sh >> $TMP
	rm -f $TMP
fi
