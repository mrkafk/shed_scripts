#!/bin/bash -x

NEWUSER="$1"

if [ -z "$NEWUSER" ]; then
	echo "specify new user for chroot as first arg"
	exit 1
fi

mkdir -p /export/"$NEWUSER"
chown root:root /export/"$NEWUSER"

jk_init -v -f -j /export/"$NEWUSER" basicshell editors extendedshell netutils ssh scp rsync sftp

groupadd "$NEWUSER"
mkdir -p /export/"$NEWUSER"/home/"$NEWUSER"
useradd -d "/export/$NEWUSER/./home/$NEWUSER" -s /usr/sbin/jk_chrootsh -g "$NEWUSER" "$NEWUSER"
chown "$NEWUSER":"$NEWUSER" /export/"$NEWUSER"/home/"$NEWUSER"
mkdir /export/"$NEWUSER"/tmp
chmod 777 /export/"$NEWUSER"/tmp

jk_cp -v -k -f  /export/"$NEWUSER"/ /usr/bin/ssh-keygen

cat /etc/passwd | grep -w "$NEWUSER" | head -n 1 >> /export/"$NEWUSER"/etc/passwd
perl -pi -e "s/\/export\/$NEWUSER\/\.//g" /export/"$NEWUSER"/etc/passwd
perl -pi -e "s/usr\/sbin\/jk_chrootsh/bin\/bash/g" /export/"$NEWUSER"/etc/passwd

cat /etc/group | grep -w "$NEWUSER" | head -n 1 >> /export/"$NEWUSER"/etc/group

