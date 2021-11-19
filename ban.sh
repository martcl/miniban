

# ban.sh Ban an IP address using iptables and add the IP address together with a ban
# timestamp to a persistent flat database file miniban.db (see format below)

IP=$1

# ----- oppgave -----
# Sjekke at det er en gyldig ip adresse


# ----- oppgave -----
# Bruk iptabels til å banne ip adressen ny regel


echo "$IP,$(date +%s)" >> miniban.db
