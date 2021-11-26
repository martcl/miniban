#!/bin/bash

# Periodically check banned IPs in miniban.db and remove them if the ban has
# expired (10 minutes). Remove the iptables rule for the IP address

# IP input
IP_I=$1

# Checks if the file was given an argument
if [[ -z "$IP_I" ]]; then
        # If not, running loop to continuously check IP bantime
        while true; do
                TIME_NOW=$(date +%s)
                sleep 1
                
                # Reads from miniban.db to check if an IP has excited the bantime
                while IFS=',' read -r IP TIMESTAMP; do
                        if [ $(( $TIME_NOW - $TIMESTAMP )) -ge 600 ]; then
                                echo "---> unban $IP"
                                # Removes rule for IP in iptables and then save
                                sudo iptables -D INPUT -s "$IP" -j REJECT > /dev/null 2>&1
                                sudo iptables-save > /dev/null
                                # Removes IP and timestamp from miniban.db
                                sed -i  "/$IP,$TIMESTAMP/d" miniban.db
                        fi
                done < miniban.db
        done
        
# Check if the given argument is a valid IPv4 adress
elif [[ "$IP_I" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "--> unban $IP_I"
        # Removes rule for IP in iptables and save
        sudo iptables -D INPUT -s "$IP_I" -j REJECT > /dev/null
        sudo iptables-save > /dev/null
        # Removes IP and timestamp from miniban.db
        sed -i  "/$IP,$TIMESTAMP/d" miniban.db
        
else
        echo "Not a valid IP address"
fi
