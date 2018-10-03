#!/bin/bash

for disk in `sudo fdisk -l | grep -Eo '(/dev/[sh]d[a-z]):' | sed -E 's/://'`;
do
	    SN=`hdparm -i $disk | grep -Eo 'SerialNo=.*' | sed -E 's/SerialNo=//'`
	    echo "$disk $SN"
done
