#!/bin/bash

# unban.sh Periodically check banned IPs in miniban.db and remove them if the ban has
# expired (10 minutes). Remove the iptables rule for the IP address

# ------ Å gjøre ------
# 1. Legge til at iptabels også unbanner
# 2. Legge til f-Lock


while true; do
  sleep 2
  TIME_NOW =$(date +%s)
  while IFS="," read -r IP TIMESTAMP; do
    echo "$IP, $TIMESTAMP"
    if [ $(( $TIME_NOW - $TIMESTAMP )) -ge 600 ]; do
      echo "Unbanner IP: $IP"
      sed -i "/$IP,$TIMESTAMP/d" miniban.db
    fi
  done < miniban.db
done
