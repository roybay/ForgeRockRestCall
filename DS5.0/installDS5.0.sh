DSHOME=$1

$DSHOME/setup \
 directory-server \
 --rootUserDN "cn=Directory Manager" \
 --rootUserPasswordFile $DSHOME/pwfile \
 --hostname opendj.roylab.com \
 --ldapPort 1389 \
 --ldapsPort 1636 \
 --httpPort 8090 \
 --httpsPort 8453 \
 --adminConnectorPort 4444 \
 --baseDN dc=roylab,dc=com \
 --ldifFile $DSHOME/ldif/roylab.ldif \
 --acceptLicense
