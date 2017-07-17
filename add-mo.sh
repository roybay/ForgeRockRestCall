MO=$1
ENV=$2

. $ENV.environment
. openidm.properties

curl --insecure \
-H "Content-Type:application/json" \
-H "X-OpenIDM-Username: $USERNAME" \
-H "X-OpenIDM-Password: $PASSWORD" \
-X POST \
--data "@./json/$MO.json" \
"$HOSTNAME/managed/$MANAGEDOBJECT?_action=create"
