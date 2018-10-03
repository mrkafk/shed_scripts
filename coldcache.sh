#!/bin/bash -i

SCRIPT=/tmp/coldcache.sh

cat >$SCRIPT <<EOF
#!/bin/bash -x
set -x
sync
echo 3 > /proc/sys/vm/drop_caches
echo DONE
EOF
chmod 700 $SCRIPT
sudo $SCRIPT
rm -f $SCRIPT


