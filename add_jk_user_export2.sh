#!/bin/bash -x

NEWUSER="$1"

if [ -z "$NEWUSER" ]; then
	echo "specify new user for chroot as first arg"
	exit 1
fi

mkdir -p /export2/"$NEWUSER"
chown root:root /export2/"$NEWUSER"

jk_init -v -f -j /export2/"$NEWUSER" basicshell editors extendedshell netutils ssh scp rsync sftp

groupadd "$NEWUSER"
mkdir -p /export2/"$NEWUSER"/home/"$NEWUSER"
useradd -d "/export2/$NEWUSER/./home/$NEWUSER" -s /usr/sbin/jk_chrootsh -g "$NEWUSER" "$NEWUSER"
chown "$NEWUSER":"$NEWUSER" /export2/"$NEWUSER"/home/"$NEWUSER"
mkdir /export2/"$NEWUSER"/tmp
chmod 777 /export2/"$NEWUSER"/tmp

jk_cp -v -k -f  /export2/"$NEWUSER"/ /usr/bin/ssh-keygen

cat /etc/passwd | grep -w "$NEWUSER" | head -n 1 >> /export2/"$NEWUSER"/etc/passwd
perl -pi -e "s/\/export2\/$NEWUSER\/\.//g" /export2/"$NEWUSER"/etc/passwd
perl -pi -e "s/usr\/sbin\/jk_chrootsh/bin\/bash/g" /export2/"$NEWUSER"/etc/passwd

cat /etc/group | grep -w "$NEWUSER" | head -n 1 >> /export2/"$NEWUSER"/etc/group

