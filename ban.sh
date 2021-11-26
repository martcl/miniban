#!/bin/bash

# Ban an IP address using iptables and add the IP address together with a ban
# timestamp to a persistent flat database file miniban.db.

IP=$1

# Check if the IP address is valid
if [[ ! "$IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "IP adress: $IP is not valid"
    exit 1
fi

# Makes a rule in iptables that ban the IP address
iptables -A INPUT -s "$IP" -j REJECT > /dev/null
iptables-save > /dev/null

# Saves the IP address and timestamp in the database
echo "$IP,$(date +%s)" >> miniban.db
echo "---> banned $IP"
