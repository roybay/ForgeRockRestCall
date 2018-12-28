USER=$1
ENV=$2

. $ENV.environment

curl --insecure \
-H "Content-Type:application/json" \
-H "X-OpenIDM-Username: $USERNAME" \
-H "X-OpenIDM-Password: $PASSWORD" \
-X PATCH \
--data "@./JSON/userAttrRemove.json" \
"$HOSTNAME/managed/user/$USER"
