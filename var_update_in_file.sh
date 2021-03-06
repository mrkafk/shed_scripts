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
NOEQSIGN="$4"

testn "$FILENAME" FILENAME "FILENAME VARNAME VALUE"
testn "$VARNAME" VARNAME "FILENAME VARNAME VALUE"
testn "$VALUE" VALUE "FILENAME VARNAME VALUE"

export LC_ALL=C

FILENAME=$(realpath "$FILENAME")

if [ ! -f "$FILENAME" ]; then
  echo "No such file or directory: $FILENAME"
  exit 1
fi

PARENT_COMMAND=$(get_parent_cmd)
ORIG_PARENT_COMMAND="$PARENT_COMMAND"
PARENT_COMMAND=$(echo "$PARENT_COMMAND" | sed 's|/|\\/|g' | sed 's|\$|\\$|g')

ORIG_VARNAME="$VARNAME"

# VALUE=$(echo "$VALUE" | sed 's|/|\\/|g' | sed 's|\$|\\$|g')
VARNAME=$(echo "$VARNAME" | sed 's|/|\\/|g' | sed 's|\$|\\$|g')

UUID=$(uuidgen)
if [ -z "$UUID" ]; then
    apt -y install uuid-runtime
    UUID=$(uuidgen)
fi

if [ "$NOEQSIGN" == "--no-equal-sign" ]; then

  if [ -z "$(egrep "^\s*${VARNAME}" $FILENAME)" ]; then
    echo "# Updated $VARNAME automatically on $(date_hm) by command: $ORIG_PARENT_COMMAND" >> "$FILENAME"
  fi

  if [ -z "$(egrep "^\s*${VARNAME}" $FILENAME)" ]; then
    echo "${ORIG_VARNAME}" >> "$FILENAME"
  fi

  set -x
  sed -i "s/^\s*$VARNAME.*/$ORIG_VARNAME    $UUID/g" "$FILENAME"
  sed -i "s|$UUID|$VALUE|" "$FILENAME"
  set +x

else

  if [ -z "$(egrep "^\s*${VARNAME}\s*=\s*" $FILENAME)" ]; then
    echo "# Updated $VARNAME automatically on $(date_hm) by command: $ORIG_PARENT_COMMAND" >> "$FILENAME"
  fi

  if [ -z "$(egrep "^\s*${VARNAME}\s*=\s*" $FILENAME)" ]; then
    echo "${ORIG_VARNAME}=" >> "$FILENAME"
  fi

  echo "VARNAME ###${VARNAME}###"

  set -x
  sed -i "s/^\s*${VARNAME}\s*=.*/$ORIG_VARNAME=$UUID/g" "$FILENAME"
  sed -i "s|$UUID|$VALUE|" "$FILENAME"
  set +x

fi
