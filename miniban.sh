#!/bin/bash
# miniban.sh Main script - watch for system authorisation events relating to SSH (secure
# shell), keep track of the number of failures per IP address, and when this is greater than or
# equal to 3, ban the IP address (see next point)

# Dette er en liste som inneholder ipadresser og hvor mange ganger de failet på å logge inn
declare -A FAIL

# Loopen leser alle nye linjer i ssh loggen og setter dem inn i LINE variabelen

#bash ./unban.sh $IP

# Loopen leser alle nye linjer i ssh loggen og setter dem inn i LINE variabelen
tail -f -n0 /var/log/auth.log | while read LINE; do
        # Hvis linjen inneholder substringen "Failed"
        ## Kanksje bruke grep?
        if [[ "$LINE" == *"Failed"* ]]; then
                echo "$LINE"

                # Henter ut IP fra linjen med regular-exspression
                # FOrbedring?? enda bedre regex
                IP=$(echo $LINE | grep -oP '(\d{1,3}\.){3}\d{1,3}')

                echo $IP

                # Hvis det er første gang brukeren har failet
                if [ ${FAIL[$IP]+_} ]; then # Hvis det finnes en Ip adresse i Arrayet
                        # Hvis brukeren har failet 3 eller flere ganger
                        if [ ${FAIL[$IP]} -ge 2 ]; then
                                # Her kan vi banne ip-en
                                bash ./ban.sh $IP
                                echo "du er bannet, og kan ikke logge på"

                        # Hvis brukeren failer +1
                        else
                                FAIL[$IP]=$(( ${FAIL[$IP]} + 1 ))
                                echo "Pluss 1, du har brukt ${FAIL[$IP]} forsøk"
                        fi
                else  # Hvis det ikke finnes i Arrayet. legg det til
                        echo "Dette er en ny IP-adresse"
                        FAIL[$IP]=1

                fi


        # Hvis brukeren suksessfult klarer å logge inn
        elif [[ "$LINE" == *"Accepted"* ]]; then
                # Forbedring.. Fjerene fra FAIL
                echo "Success! :-)"
                ${FAIL}
        fi

done
