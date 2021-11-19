# miniban.sh Main script - watch for system authorisation events relating to SSH (secure
# shell), keep track of the number of failures per IP address, and when this is greater than or
# equal to 3, ban the IP address (see next point)


# Husk F-Lock

# ------ Oppgave -------
# Hint: Use the tail command to monitor activity in the logfile /var/log/auth.log
# Lese loggen til ssh /var/log/auth.log

# ------ Oppgave --------
# Sjekke om ip-adressen har logget inn feil mange ganger

# ------ Oppgave --------
# Hint: IFS="," read IP TIMESTAMP < miniban.db; echo $IP $TIMESTAMP
# Lese loggen til ssh /var/log/auth.log


# ------ Oppgave --------
# Banne ip adressen med ./ban.sh <ip-adresse>
