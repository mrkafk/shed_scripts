#!/bin/bash


list_ws.sh | while read x; do
	SNAME=/tmp/check_running_"$x"
	cat >$SNAME <<EOF
#!/bin/bash

S=\$(ping -c 1 $x | grep transmitted | grep -v "0 received")
if [ -n "\$S" ]; then
     echo "$x is alive"
fi
sleep 1
rm -f "$SNAME"

EOF
	chmod 700 "$SNAME"
	"$SNAME" &
done

echo
