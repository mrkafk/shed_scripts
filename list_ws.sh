#!/bin/bash

cat /etc/dhcp/dhcpd.conf  | grep -v '#' | grep host | grep host.name | awk '{print $2;}' | grep -v ljet | sort
