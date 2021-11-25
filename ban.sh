#!/bin/bash
# Ban an IP address using iptables and add the IP address together with a ban
# timestamp to a persistent flat database file miniban.db.

IP=$1

# Sjekker om ip adressen er gyldig
if [[ ! "$IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "IP adress: $IP is not valid"
    exit 1
fi

# Lager regel med iptabels som banner ip adresser
iptables -A INPUT -s "$IP" -j REJECT > /dev/null
iptables-save > /dev/null

# Lagrer ip-adressen i databasen sammen med en timestamp
echo "$IP,$(date +%s)" >> miniban.db
echo "---> banned $IP"
