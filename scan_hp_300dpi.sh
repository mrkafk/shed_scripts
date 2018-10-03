#!/bin/bash

FNAME="$1"

if [ -z "$FNAME" ]; then
	FNAME=$$.png
fi

scanimage -d 'hpaio:/usb/psc_1310_series?serial=MY11112' --resolution=300 --format=png -p > "$FNAME"
echo
echo

NFNAME=`basename "$FNAME" .png`
NFNAME="$NFNAME.jpg"

convert "$FNAME" "$NFNAME"

rm -f "$FNAME"

echo "$NFNAME"

