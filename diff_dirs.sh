#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

. "$SCRIPTDIR"/snippets.sh

function usage () {
  echo "Usage:"
  echo "diff_dirs.sh dir1 dir2"
}

if [ -z "$1" ] || [ -z "$2" ];then
  usage
  exit 1
fi

TMPF1="/tmp/$$.tmpf1"
TMPF2="/tmp/$$.tmpf2"


export LC_ALL=C

diff -q -r "$1" "$2" | grep -v 'Only in' | awk '{print $2, $4;}' | while read x; do
  LEFT=$(echo "$x" | awk '{print $1;}')
  RIGHT=$(echo "$x" | awk '{print $2;}')
  echo "#### $LEFT <=> $RIGHT ####"
  cat "$LEFT" | egrep -v "^\s*#" | tr -s '\n' > "$TMPF1"
  cat "$RIGHT" | egrep -v "^\s*#" | tr -s '\n' > "$TMPF2"
  diff "$TMPF1" "$TMPF2"
  echo
done
