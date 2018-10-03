#!/bin/bash

if [ -n "$1" ]; then
	MACIP=`/usr/local/bin/find_ip_mac_dhcpd.py "$1"`
	echo "$1 $MACIP"
	MAC=`/usr/local/bin/find_ip_mac_dhcpd.py $1 | awk '{print $1;}'`
	set -x
	etherwake -i br0 -D "$MAC"
	set +x
	echo
	#ping -c 2 "$1"
	echo
else
	echo "specify workstation hostname as first argument"
fi
