#!/bin/bash -x


NAME="$1"
MAC="$2"
TYPE="$3"

testn () {
	if [ -z "$1" ]; then
		echo "Param $2 empty. Aborting"
		echo "Usage: $0 NAME MAC TYPE"
		exit 1
	fi
}

testn "$NAME" NAME


vboxmanage unregistervm ${NAME} --delete
sudo lvcreate -n ${NAME} -L 10G vg
vboxmanage internalcommands createrawvmdk -filename "${NAME}.vmdk" -rawdisk /dev/vg/${NAME}
vboxmanage createvm --name ${NAME} --ostype Debian_64 --register
vboxmanage storagectl ${NAME} --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storageattach ${NAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${NAME}.vmdk"
vboxmanage storagectl ${NAME} --name "IDE Controller" --add ide
vboxmanage storageattach ${NAME} --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ~/iso/debian-7.2.0-amd64-netinst-preseed.iso

vboxmanage modifyvm ${NAME} --ioapic on
vboxmanage modifyvm ${NAME} --boot1 dvd --boot2 disk --boot3 none --boot4 none
vboxmanage modifyvm ${NAME} --memory 1024 --vram 128
vboxmanage modifyvm $NAME --nic1 nat
HOSTONLYIF=`vboxmanage hostonlyif create 2>&1 | grep Interface | awk "{gsub(/'/,\"\"); print $2;}" | awk '{print $2;}'`
vboxmanage hostonlyif ipconfig ${HOSTONLYIF} --ip 192.168.123.105 --netmask 255.255.255.0
vboxmanage modifyvm ${NAME} --nic2 hostonly
vboxmanage modifyvm ${NAME} --nictype2 82545EM
vboxmanage modifyvm ${NAME} --hostonlyadapter2 ${HOSTONLYIF}




