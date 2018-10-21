#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

TMP=/tmp/$$.pbdf
FLIST=/tmp/$$.flist

mkdir -p $TMP

cat >$FLIST <<EOF
.bash_profile
.dircolors
.vimrc
EOF

cd

cp -av $(cat "$FLIST") "$TMP"

cd "$TMP"

set -x
tar cfv shell_basic.tar $(cat "$FLIST")

cp shell_basic.tar "$SCRIPTDIR"/other_utils

cd "$SCRIPTDIR"/other_utils
git add shell_basic.tar
git commit -m "Updated shell_basic.tar on `date`"

cd
rm -rf "$TMP"
rm -f "$FLIST"

