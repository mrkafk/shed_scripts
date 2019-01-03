#!/bin/bash

JAILS=`fail2ban-client status | grep "Jail list" | sed -E 's/^[^:]+:[ \t]+//' | sed 's/,//g'`
for JAIL in $JAILS
do
  fail2ban-client status "$JAIL" | grep 'Banned IP list:' | awk -F"\t" '{print $2;}' | tr -s ' ' | tr ' ' '\n' | while read IP; do
    set -x
    fail2ban-client set "$JAIL" unbanip "$IP"
    set +x
  done
done
