#!/bin/bash

. /opt/opendj-scripts/autobackups/autobackups.properties

cd $BACKUP_DIR
mkdir ./temp

for i in "${DAILY_BACKUP_SERVICES[@]}"
do
        LDIFFILE=$ENV-${TYPES[$i]}-${BACKEND[$i]}-$OPENDJ-$TODAY.ldif

        $OPENDJ_HOME/${TYPES[$i]}/bin/export-ldif \
        --hostname $HOSTNAME \
        --port ${PORTS[$i]} \
        --bindDN "cn=Directory Manager" \
        --bindPasswordFile $PASSWORDFILE \
        --backendID ${BACKEND[$i]} \
        --includeBranch ${BRANCH[$i]} \
        --ldifFile $BACKUP_DIR/temp/$LDIFFILE \
        --start 0 \
        --trustAll

        aws s3 cp $BACKUP_DIR/temp/$LDIFFILE s3://$BUCKET/${TYPES[$i]}/$OPENDJ/daily/$LDIFFILE
        rm $BACKUP_DIR/temp/$LDIFFILE

        aws s3 ls s3://$BUCKET/${TYPES[$i]}/$OPENDJ/daily/ | grep $ENV-${TYPES[$i]}-${BACKEND[$i]}-$OPENDJ-$REMOVE_DATE
        if [[ $? -ne 1 ]]; then
                aws s3 rm s3://$BUCKET/${TYPES[$i]}/$OPENDJ/daily/ --recursive --exclude "*ldif" --include "$ENV-${TYPES[$i]}-${BACKEND[$i]}-$OPENDJ-$REMOVE_DATE*"
        fi
done

rm -rf $BACKUP_DIR/temp
