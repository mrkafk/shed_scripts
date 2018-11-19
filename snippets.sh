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
  date +'%d_%m_%Y-%H_%M'
}

function date_mdy () {
  date +'%m_%d_%Y'
}

function date_dmy () {
  date +'%d_%m_%Y'
}

# Portable way of getting full command path of $PPID - unfortunately on older systems 'ps -wwwwo cmd  -q $PPID' complains about 'Unsupported SysV option'
function get_parent_cmd () {
	PARENT_CMD=$(ps ax -o pid,cmd  $PPID | egrep "\s*${PPID}" | grep -v "ps ax -o pid,cmd" | grep -v grep | sed -e 's/^\s*[0-9]* //g')
	echo "$PARENT_CMD"
}

# List users belonging to the group.
function group_users () {
	if [ -z "$1" ]; then
		echo "Specify group name as first argument."
		exit 1
	fi

	getent passwd | sort | while IFS=: read name trash
	do
			groups $name 2>/dev/null | cut -f2 -d: | grep -i -q -w "$1" && echo $name
	done
}



