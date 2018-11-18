#!/bin/bash -x

NEWUSER="$1"

if [ -z "$NEWUSER" ]; then
	echo "specify new user for chroot as first arg"
	exit 1
fi

BASE=$BASE

mkdir -p $BASE/"$NEWUSER"
chown root:root $BASE/"$NEWUSER"

jk_init -v -f -j $BASE/"$NEWUSER" basicshell editors extendedshell netutils ssh scp rsync sftp

groupadd "$NEWUSER"
mkdir -p $BASE/"$NEWUSER"/home/"$NEWUSER"
useradd -d "$BASE/$NEWUSER/./home/$NEWUSER" -s /usr/sbin/jk_chrootsh -g "$NEWUSER" "$NEWUSER"
chown "$NEWUSER":"$NEWUSER" $BASE/"$NEWUSER"/home/"$NEWUSER"
mkdir $BASE/"$NEWUSER"/tmp
chmod 777 $BASE/"$NEWUSER"/tmp

jk_cp -v -k -f  $BASE/"$NEWUSER"/ /usr/bin/ssh-keygen
chmod 755 $BASE/"$NEWUSER"/bin

cat /etc/passwd | grep -w "$NEWUSER" | head -n 1 >> $BASE/"$NEWUSER"/etc/passwd
perl -pi -e "s/\$BASE\/$NEWUSER\/\.//g" $BASE/"$NEWUSER"/etc/passwd
perl -pi -e "s/usr\/sbin\/jk_chrootsh/bin\/bash/g" $BASE/"$NEWUSER"/etc/passwd

cat /etc/group | grep -w "$NEWUSER" | head -n 1 >> $BASE/"$NEWUSER"/etc/group

PW=$(pwgen -A 11 | head -n 1 | awk '{print $1;}')
echo -e "$PW\n$PW" | passwd "$NEWUSER"

echo "Password for $NEWUSER: $PW"

SSHDIR="$BASE/$NEWUSER/home/$NEWUSER/.ssh"
mkdir -p "$SSHDIR"
chown "$NEWUSER:$NEWUSER" "$SSHDIR"
chmod 700 "$SSHDIR"
echo "Paste public SSH key, finish with Ctrl-D"
set -x
cat >>"$SSHDIR"/authorized_keys
set +x
