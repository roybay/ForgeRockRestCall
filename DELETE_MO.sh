MO=$1
ENV=$2

. $ENV.environment
. openidm.properties

curl --insecure \
-H "X-OpenIDM-Username: $USERNAME" \
-H "X-OpenIDM-Password: $PASSWORD" \
-X DELETE \
"$HOSTNAME/managed/$MANAGEDOBJECT/$MO"
