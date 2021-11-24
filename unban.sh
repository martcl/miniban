#!/bin/bash

# unban.sh Periodically check banned IPs in miniban.db and remove them if the ban has
# expired (10 minutes). Remove the iptables rule for the IP address

# ------ Å gjøre ------
# 1. Legge til at iptabels også unbanner
# 2. Legge til f-Lock

IP_I=$1

while true; do
        if [[ -z "$IP_I" ]]; then
                while true; do
                TIME_NOW=$(date +%s)
                sleep 1
                while IFS=',' read -r IP TIMESTAMP; do
                        if [ $(( $TIME_NOW - $TIMESTAMP )) -ge 10 ]; then
                                echo "---> unban $IP"
                                sudo iptables -D INPUT -s "$IP" -j REJECT
                                sudo iptables-save
                                sed -i  "/$IP,$TIMESTAMP/d" miniban.db

                        fi
                done < miniban.db
                done
        elif [[ "$IP_I" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                echo "--> unban $IP_I"
                sudo iptables -D INPUT -s "$IP_I" -j REJECT > /dev/null
                sudo iptables-save > /dev/null
                break
        else
                echo "slutt"
                break
        fi
done

