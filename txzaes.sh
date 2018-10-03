#!/bin/bash


# based on http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

TMP=/tmp/$$.dat
TMPD=/tmp/$$.unt

function check_untar () {
	rm -rf "$TMPD" &>/dev/null
	mkdir -p "$TMPD"
	tar xf "$1" -C "$TMPD"
	if [ $? -ne 0 ]; then
		echo 
		echo "ERROR UNTARING THE FILE $1"
		echo "INVESTIGATE."
		echo

	fi
}

for G in "$@"; do
	if [ -f "$G" ]; then
		F=`basename "$G" .gpg`
		gpg -d "$G" > "$TMP"
		if [ $? -eq 0 ]; then
			mv "$TMP" "$F"
			echo "Decrypted $G to $F."
			check_untar "$F"
		else
			echo "Problem decrypting $G. File skipped."
		fi
		echo
	else
		echo "File $G not found."
	fi
done


rm -rf "$TMP"
