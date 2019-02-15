#!/bin/bash

#This script create s3 bucket and required folder structure for auto backup

. /opt/opendj-scripts/autobackups/autobackups.properties

# Old version if aws cli
aws s3api create-bucket --bucket $BUCKET --region $REGION

# New version of aws cli works
# aws s3api create-bucket --bucket $BUCKET --region $REGION --create-bucket-configuration LocationConstraint=$REGION

for i in "${!TYPES[@]}"
do
        aws s3api put-object --bucket $BUCKET  --key ${TYPES[$i]}/
        for j in "${!SERVERS[@]}"
        do
                aws s3api put-object --bucket $BUCKET --key ${TYPES[$i]}/${SERVERS[$j]}
                for k in "${!BACKUPS[@]}"
                do
                        aws s3api put-object --bucket $BUCKET --key ${TYPES[$i]}/${SERVERS[$j]}/${BACKUPS[$k]}
                done
        done
done
