#!/bin/bash -x

TMP=/tmp/$$.txt

INTF=eth0
WIF=wlan0

NMCONF=/etc/NetworkManager/NetworkManager.conf

function cmtout {
    sudo perl -pi -e 's/\[keyfile\]/#\[keyfile\]/' "$NMCONF"
    sudo perl -pi -e 's/unmanaged-devices/#unmanaged-devices/' "$NMCONF"
}

function uncmt {
    sudo perl -pi -e 's/^[ #]+\[keyfile\]/\[keyfile\]/' "$NMCONF"
    sudo perl -pi -e 's/^[ #]+unmanaged-devices/unmanaged-devices/' "$NMCONF"
}


case "$1" in

	"on")
	#sudo cp /etc/network/interfaces $TMP
	#U=`id -un`
	#sudo chown "$U" $TMP 
	#cat >>$TMP <<EOF
#iface "$INTF" inet static
#        address 192.168.8.1
#        netmask 255.255.255.0
#        gateway 192.168.8.1
#EOF
	#sudo cp -f $TMP /etc/network/interfaces
	#sudo chown root:root /etc/network/interfaces
	
	sudo bash -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
	uncmt
	sudo service network-manager restart
	sleep 1
	sudo ip link set "$INTF" up
	sudo ip addr add 192.168.8.1/24 dev "$INTF"
	sudo iptables -t nat -A POSTROUTING -o "$WIF" -j MASQUERADE
	sudo service isc-dhcp-server restart
	;;

	"off")
	#sudo cat /etc/network/interfaces | awk '{if($0 ~ /iface eth0 inet static/) {getline; getline; getline;} else {print $0;}}' > $TMP
	#sudo cp -f $TMP  /etc/network/interfaces
	cmtout
	sudo service network-manager restart
	sudo service isc-dhcp-server stop
	sudo ip addr del 192.168.8.1/24 dev "$INTF"
	sudo iptables -t nat -F
	;;

	
	*)
	echo "unrecognized option ($1)"
	;;
esac

rm -f $TMP
