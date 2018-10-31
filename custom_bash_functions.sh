#!/bin/bash

function cx ()
{
            cd `/usr/local/bin/xd \$*`
}

function whichc ()
{
	W=$(which "$1")
	D=$(dirname "$W")
	echo "$D"
	cd "$D"
}

# Find all virtualenvs in current dir, activate on selection with dialog
function va () {
	TMP1=/tmp/$$.1
	TMP2=/tmp/$$.2
	find . -name activate | grep -w 'bin/activate' | awk '{print NR " " $0 ;}' > "$TMP1"
	whiptail --clear --menu "Select virtualenv:" 24 70 $(wc -l "$TMP1" | cut -d " " -f 1)  $(cat "$TMP1")  2>"$TMP2"
	# dialog --clear --menu "Select virtualenv:" 24 70 $(wc -l "$TMP1" | cut -d " " -f 1)  $(cat "$TMP1")  2>"$TMP2"
	NUM=$(cat $TMP2)
	VEPATH=$(sed "${NUM}q;d" "$TMP1" | awk '{print $2;}')
	source "$VEPATH"
	rm -f "$TMP1"
	rm -f "$TMP2"
}

function vwhich () {
	TMP1=/tmp/$$.1
	TMP2=/tmp/$$.2
	which -a "$1" | sort | uniq > "$TMP1"
	if [ $(cat "$TMP1" | wc -l | awk '{print $1}') -eq 1 ]; then
		realpath $(cat "$TMP1")
		sleep 1
		vi $(cat "$TMP1")
	else
		which -a "$1" | sort | uniq | awk '{print NR " " $0 ;}' > "$TMP1"
		whiptail --clear --menu "Select one of the files to edit:" 24 70 $(wc -l "$TMP1" | cut -d " " -f 1)  $(cat "$TMP1")  2>"$TMP2"
		NUM=$(cat $TMP2)
		FPATH=$(sed "${NUM}q;d" "$TMP1" | awk '{print $2;}')
		echo "$FPATH"
		sleep 1
		vi "$FPATH"
	fi
	rm -f "$TMP1"
}

# Select hostfile for hss
function hs () {
    BASEDIR=/usr/local/etc
	TMP1=/tmp/$$.1
	TMP2=/tmp/$$.2
	if [ -d /usr/local/etc ]; then
		find /usr/local/etc -name "*.hostfile" -printf "%f\n" | sort | awk '{print NR " " $0;}' | sort -n > "$TMP1"
	else
		find ./ -name "*.hostfile" -printf "%f\n" | sort | awk '{print NR " " $0;}' | sort -n > "$TMP1"
	fi
	if [ -f ~/.config/shed_scripts/hs.last ]; then
		whiptail --clear --default-item $(cat ~/.config/shed_scripts/hs.last) --menu "Select hss hostfile:" 24 70 $(wc -l "$TMP1" | cut -d " " -f 1)  $(cat "$TMP1") 2> "$TMP2"
	else
		whiptail --clear --menu "Select hss hostfile:" 24 70 $(wc -l "$TMP1" | cut -d " " -f 1)  $(cat "$TMP1") 2> "$TMP2"
	fi
    NUM=$(cat "$TMP2")
    if [ -n "$NUM" ]; then
		shed_config_mkdirp.sh
		echo "$NUM" > ~/.config/shed_scripts/hs.last
        HOSTFILE=$(sed "${NUM}q;d" "$TMP1" | awk '{print $2;}')
        rm -f "$TMP1"
        rm -f "$TMP2"
        hss -c '-C -x' -f "$BASEDIR/$HOSTFILE"
    fi
}

function abspath() {
	old=`pwd`;new=$(dirname "$1");
	if [ "$new" != "." ]; then
		cd $new;
	fi
	file=`pwd`/$(basename "$1")
	cd $old
	echo $file
}

function elocate() {
	locate -i "$1" | egrep "/$1\$"
}

function f() {
	find . -type f -name "$1"
}

function fa() {
	find . -type f -name "*${1}*"
}

function fullpath () {
	echo "$(pwd)/$1"
}

function sbp () {
	echo "Sourcing ~/.bash_profile in current shell."
	source ~/.bash_profile
}

# Remove duplicates in PATH
function remove_PATH_dups () {
	if [ -n "$PATH" ]; then
	old_PATH=$PATH:; PATH=
	while [ -n "$old_PATH" ]; do
		x=${old_PATH%%:*}       # the first remaining entry
		case $PATH: in
		*:"$x":*) ;;          # already there
		*) PATH=$PATH:$x;;    # not there yet
		esac
		old_PATH=${old_PATH#*:}
	done
	PATH=${PATH#:}
	unset old_PATH x
	export PATH
	fi
}

