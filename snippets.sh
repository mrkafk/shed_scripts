#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPTDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"


testn () {
	if [ -z "$1" ]; then
		echo "Param $2 empty. Exit."
		if [ -n "$3" ]; then
			echo
			echo "Required arguments:"
			echo "    $3"
		fi
		exit 1
	fi
}

function date_hm () {
  date +'%m_%d_%Y-%H_%M'
}

function date_mdy () {
  date +'%m_%d_%Y'
}

