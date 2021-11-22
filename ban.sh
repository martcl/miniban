

# ban.sh Ban an IP address using iptables and add the IP address together with a ban
# timestamp to a persistent flat database file miniban.db (see format below)

IP=$1

# ----- oppgave -----
# Sjekker om ip adressen er gyldig
# (Ganske sikker på at deb fungerer, men det er ikke noe poeng
# Å bruke den når vi driver å tester uansett så la den være kommentert)
#if (! $IP =~ ^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$); do
#    echo "Ikke gyldig ip adresse"
#    exit 1


# ----- oppgave -----
# Lager regel med iptabels som banner ip adresser
iptabels -A INPUT -s "$IP" -p tcp --destination-port 22 -j DROP


# Lagere ip-adressen i databasen sammen med en timestamp
echo "$IP,$(date +%s)" >> miniban.db
