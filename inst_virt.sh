#!/bin/bash

NAME=testit

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
testn "$MAC" MAC
testn "$TYPE" TYPE



#virsh destroy mailserver
#virsh undefine mailserver

# MAC 52:54:00:20:fa:0e

if [ "$TYPE" == "linux" ]; then
        lvcreate -n ${NAME} -L 10G vg
	virt-install --name=${NAME} --virt-type=kvm --ram=2048 --disk path=/dev/vg/${NAME},format=raw --network bridge:br0 --mac="$MAC" --os-type=linux --os-variant=debianwheezy --virt-type=kvm --video=vga --cdrom /bigstore/iso/debian-7.2.0-amd64-netinst-preseed.iso
elif [ "$TYPE" == "win7vio" ]; then
        lvcreate -n ${NAME} -L 100G vg
        virt-install --name=${NAME} --virt-type=kvm --ram=2048 --disk path=/dev/vg/${NAME},format=raw,bus=virtio --network bridge:br0 --mac="$MAC" --os-type="windows" --os-variant=win7 --video=vga --disk /bigstore/iso/virtio-win-0.1-65.iso,device=cdrom --disk '/bigstore/images/soft/Windows7-Ultimate-Sp1-X86&X64-RTM-Genuine-Untuched(Dark4m)/X64-64bit/X17-59465.iso',device=cdrom
else
	virt-install --name=${NAME} --virt-type=kvm --ram=2048 --disk path=/dev/vg/${NAME},format=raw --network bridge:br0 --mac="$MAC" --os-type="$TYPE" --os-variant=win7 --import --virt-type=kvm --video=vga
fi



