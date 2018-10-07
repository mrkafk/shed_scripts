#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

TMP=/tmp/$$.pbdf

lsblk | grep disk | awk '{print $1;}' | sort | while read x; do
  DISK="/dev/$x"
  TEMPERATURE=$(smartctl -a "$DISK" | grep Temperature_Celsius | awk '{print $10}')
  echo "$DISK $TEMPERATURE" >> $TMP
done

cat "$TMP"
rm -f "$TMP"
