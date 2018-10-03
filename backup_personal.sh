#!/bin/bash

FNAME=/tmp/backup_personal-`id -u -n`-`date '+%Y_%m_%d'`

SENDER=files@host.name
RECIPIENT=recip@ient.com
SMTPUSER=smtpuser
SMTPPASS=pass
SMTPHOST=host.name

TMPF=/tmp/$$.txt

cat >$TMPF <<EOF
/home/username/.mozilla/firefox/pp1966g8.default/bookmarks.html
/home/username/txt
/etc
EOF

cd /home/username

sudo tar cf ${FNAME}.tar $(cat $TMPF) --exclude=/home/username/bin/.svn --exclude=/home/username/bin/data --exclude=/home/username/bin/KeePass

sudo chown username:users ${FNAME}.tar

echo 
read -s -p "Type passphrase: " PASS

if [ -z "$PASS" ]; then
    echo "Passphrase empty. Aborting."
    exit 1
fi

7z a -mx=9  -p${PASS} ${FNAME}.7z ${FNAME}.tar
ls -lh ${FNAME}.tar
rm -f ${FNAME}.tar
ls -lh ${FNAME}.7z

STATUS=$?

mkdir -p ~/Documents/backups
set -x
cp ${FNAME}.7z ~/Documents/backups
scp ${FNAME}.7z root@host.name:/home/username/bk
set +x


rm -f ${FNAME}.7z
rm -f $TMPF

exit $STATUS

