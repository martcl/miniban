echo "Programmet starter"

IP=$1

echo "$IP,$(date +%s)" >> miniban.db

cat miniban.db

