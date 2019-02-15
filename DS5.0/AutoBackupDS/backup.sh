#!/bin/bash

. /opt/opendj-scripts/autobackups/autobackups.properties

cd $BACKUP_DIR

for i in "${WEEKLY_BACKUP_SERVICES[@]}"
do
        DIRECTORY=$BACKUP_DIR/temp/$ENV-${TYPES[$i]}-$OPENDJ-$TODAY

        $OPENDJ_HOME/${TYPES[$i]}/bin/backup \
        --hostname $HOSTNAME \
        --port ${PORTS[$i]} \
        --bindDN "cn=Directory Manager" \
        --bindPasswordFile $PASSWORDFILE \
        --backupDirectory $DIRECTORY \
        --backUpAll \
        --start 0 \
        --trustAll

        cd $BACKUP_DIR/temp
        sleep 30
        zip -r $ENV-${TYPES[$i]}-$TODAY  $ENV-${TYPES[$i]}-$OPENDJ-$TODAY/

        aws s3 cp $ENV-${TYPES[$i]}-$TODAY.zip  s3://$BUCKET/${TYPES[$i]}/$OPENDJ/weekly/$ENV-${TYPES[$i]}-$OPENDJ-$TODAY.zip
        cd ..

        aws s3 ls s3://$BUCKET/${TYPES[$i]}/$OPENDJ/weekly/ | grep $ENV-${TYPES[$i]}-$OPENDJ-$REMOVE_DATE
        if [[ $? -ne 1 ]]; then
                aws s3 rm s3://$BUCKET/${TYPES[$i]}/$OPENDJ/weekly/ --recursive --exclude "*zip" --include "$ENV-${TYPES[$i]}-$OPENDJ-$REMOVE_DATE*"
        fi
done

rm -rf $BACKUP_DIR/temp
