#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

. "$SCRIPTDIR"/snippets.sh

TMPF="/tmp/$$.f"
MIGR="/tmp/migrate_1"
# MIGR="/tmp/migrate_$$"

if [ -z "$1" ]; then
  echo "Specify group name as first argument."
  exit 1
fi

group_users "$1" >"$TMPF"

echo "Users to be migrated:"
cat "$TMPF"
echo

mkdir -p "$MIGR"
cat "$TMPF" | while read x; do

done

rm -f "$TMPF"

