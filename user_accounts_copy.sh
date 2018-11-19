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

MIGR_GROUP="$1"

group_users "$MIGR_GROUP" >"$TMPF"

echo "Users to be migrated:"
cat "$TMPF"
echo

# TODO remove
rm -rf "$MIGR"/*

mkdir -p "$MIGR"
cd "$MIGR"

cp "$TMPF" "users.txt"

touch passwd_migrate
touch shadow_migrate

truncate -s 0 passwd_migrate
truncate -s 0 shadow_migrate

cat <<EOF >>"migrate_script.sh"
  groupadd "$MIGR_GROUP"

EOF


cat "$TMPF" | while read UNAME; do
  egrep "^${UNAME}:" /etc/passwd >> passwd_migrate
  egrep "^${UNAME}:" /etc/shadow >> shadow_migrate
done

rm -f "$TMPF"

