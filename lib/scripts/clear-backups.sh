#!/bin/bash

# GET VARIABLES
BUCKET_NAME=$1
MAX_BACKUPS=10
COUNT_BACKUPS=$(aws s3 ls s3://$BUCKET_NAME/ --recursive | wc -l)

while [ $COUNT_BACKUPS -gt $MAX_BACKUPS ]
do
  OLDER_BACKUP=$(aws s3 ls s3://$BUCKET_NAME/ --recursive | awk '{print $4}' | tail -n +1 | head -1)
  echo "\n✨   DELETING ${OLDER_BACKUP}\n"
  aws s3api delete-object --bucket $BUCKET_NAME --key $OLDER_BACKUP
  COUNT_BACKUPS=$(aws s3 ls s3://$BUCKET_NAME/ --recursive | wc -l)
done

echo '\n✨   BACKUP CLEANUP\n'
