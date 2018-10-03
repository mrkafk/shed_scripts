#!/bin/bash 

/usr/local/bin/detect_faulty_md.py
if [ $? -ne 0 ]; then
	TMP=/tmp/$$.txt
	cat /proc/mdstat > $TMP
	echo >> $TMP
	echo "Disk serial numbers:" >> $TMP
	/usr/local/bin/disk_serial_no.sh >> $TMP
	sfile -t mrkafk@gmail.com -f logs@host.name -n "$LOG" -h mailserver -s "RAID disk failure on host `hostname`" -b $TMP -n $TMP
	rm -f $TMP
fi
