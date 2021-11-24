#!/bin/bash
# miniban.sh Main script - watch for system authorisation events relating to SSH (secure
# shell), keep track of the number of failures per IP address, and when this is greater than or
# equal to 3, ban the IP address (see next point)

# Dette er en liste som inneholder ipadresser og hvor mange ganger de failet på å logge inn
declare -A FAIL

trap func exit

sudo ./unban.sh &

function func() {
        echo ""

        ps aux | grep "unban.sh" | awk '{print $2}' | while read NUM; do
                kill -9 $NUM 

        done
        echo "miniban is now turned OFF"
}

# Loopen leser alle nye linjer i ssh loggen og setter dem inn i LINE variabelen
tail -f -n0 /var/log/auth.log | while read LINE; do
        # Hvis linjen inneholder substringen "Failed"
        if [[ "$LINE" == *"Failed"* ]]; then
                # Henter ut IP fra linjen med regular-exspression
                # FOrbedring?? enda bedre regex
                IP=$(echo $LINE | grep -oP '(\d{1,3}\.){3}\d{1,3}')               

                echo "request from $IP"

                # Hvis det er første gang brukeren har failet
                if [ ${FAIL[$IP]+_} ]; then # Hvis det finnes en Ip adresse i Arrayet
                        # Hvis brukeren har failet 3 eller flere ganger
                        if [ ${FAIL[$IP]} -ge 2 ]; then
                                # Her kan vi banne ip-en
                                bash ./ban.sh $IP
                                unset "FAIL[$IP]"

                        # Hvis brukeren failer +1
                        else
                                FAIL[$IP]=$(( ${FAIL[$IP]} + 1 ))
                        fi
                else
                        FAIL[$IP]=1
                fi
        # Hvis brukeren suksessfult klarer å logge inn
        elif [[ "$LINE" == *"Accepted"* ]]; then
                # Forbedring.. Fjerene fra FAIL
                unset "FAIL[$IP]"
        fi
done

