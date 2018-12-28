#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

TMPF="/tmp/tmpf_${SCRIPTNAME}.$$"

mdadm --query --detail /dev/md{0..9} 2>/dev/null | egrep '^/dev' | sed 's|:||' | while read x; do
	mdadm --query --detail "$x" | egrep -w '\s*State\s*:' | sed -E 's/State\s*:\s*clean(.*)/\1/' > "$TMPF"
	mdadm --query --detail "$x" | egrep 'degraded|faulty' >> "$TMPF"
	STATUS=$(cat "$TMPF")
done

