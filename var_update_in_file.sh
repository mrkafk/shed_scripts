#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

. "$SCRIPTDIR"/snippets.sh

FILENAME="$1"
VARNAME="$2"
VALUE="$3"

testn "$FILENAME" FILENAME "FILENAME VARNAME VALUE"
testn "$VARNAME" VARNAME "FILENAME VARNAME VALUE"
testn "$VALUE" VALUE "FILENAME VARNAME VALUE"

export LC_ALL=C

FILENAME=$(realpath "$FILENAME")

if [ ! -f "$FILENAME" ]; then
  echo "No such file or directory: $FILENAME"
  exit 1
fi

PARENT_COMMAND=$(ps -wwwwo cmd  -q $PPID | egrep -v '^CMD')

if [ -z "$(egrep "^\s*${VARNAME}=" $FILENAME)" ]; then
  echo "# Added $VARNAME=$VALUE automatically on $(date_hm) by command: $PARENT_COMMAND" >> "$FILENAME"
fi

if [ -z "$(egrep "^\s*${VARNAME}=" $FILENAME)" ]; then
  echo "${VARNAME}=" >> "$FILENAME"
fi

VARVAL="$VARNAME=$VALUE"
VMD5=$(echo "$VARVAL" | md5sum | awk '{print $1;}')

set -x
sed -i "s/#.*$VMD5.*/# Updated $VARNAME automatically on $(date_hm) by command: $PARENT_COMMAND # Do not delete: $VMD5/g" "$FILENAME"
sed -i "s/^\s*$VARNAME=.*/$VARNAME=$VALUE/g" "$FILENAME"
set +x
