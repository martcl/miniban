#!/bin/bash

# Main script - watch for system authorisation events relating to SSH (secure
# shell), keep track of the number of failures per IP address, and when this is greater than or
# equal to 3, ban the IP address.

echo "miniban is now turned ON"

# This is an array that contains IP addresses and how many failed attempts to login
declare -A FAIL

trap func exit

sudo ./unban.sh &

# A function that runs when the user exits the miniban.sh script
function func() {
        echo ""
        
        # Retrieves the process page for all processes that contain unban.sh and terminates them
        ps aux | grep "unban.sh" | awk '{print $2}' > /dev/null | while read NUM; do
                kill -9 $NUM 
        done
        echo " miniban is now turned OFF"
}

# The loop reads all new lines in the ssh log and puts them in the LINE variable
tail -f -n0 /var/log/auth.log | while read LINE; do
        # If the line contains the substring "Failed"
        if [[ "$LINE" == *"Failed"* ]]; then
        
                # Retrieves the IP from the line with regular-expression

                IP=$(echo $LINE | grep -oP '(\d{1,3}\.){3}\d{1,3}')               

                echo "request from $IP"

                # Checks if the IP address exists in the array "FAIL"
                if [ ${FAIL[$IP]+_} ]; then 
                
                        # If the user fails 3 or more times and is not in the miniban.whitelist
                        if [ ${FAIL[$IP]} -ge 2 ] && grep -vq "$IP$" miniban.whitelist; then

                                # Here the ban.sh script is executed
                                bash ./ban.sh $IP
                                unset "FAIL[$IP]"

                        # If the user fails multiple times
                        else
                                FAIL[$IP]=$(( ${FAIL[$IP]} + 1 ))
                        fi
                # The first failed attempt from the user
                else
                        FAIL[$IP]=1
                fi
        # If the user gets a successfull login, then they get deleted from the array "FAIL"
        elif [[ "$LINE" == *"Accepted"* ]]; then
                unset "FAIL[$IP]"
        fi
done
