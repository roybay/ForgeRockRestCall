USER=$1
CERT=$2
ENV=$3
sed '1,1d' $CERT > temp1.crt
sed '$d' temp1.crt > temp2.crt
rm temp1.crt
USERCERT=$(echo "$a" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' temp2.crt)
rm temp2.crt


. $ENV.environment

curl --insecure \
-H "Content-Type:application/json" \
-H "X-OpenIDM-Username: $USERNAME" \
-H "X-OpenIDM-Password: $PASSWORD" \
-X PATCH \
--data '[{
        "operation": "add",
        "field": "userCertificate",
        "value": ["'$USERCERT'"]
}]' \
"$HOSTNAME/managed/user/$USER"
