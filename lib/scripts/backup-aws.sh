#!/bin/bash

# GET VARIABLES
BUCKET_NAME=$1
ZIP_NAME=$(date "+%Y%m%d-%H%M%S-backup.zip")

touch ./process/backup.running
echo '\n✨   STARTING BACKUP\n'
for d in /var/www/*/ ; do
    SITE=$(echo $d | sed 's/\///g' | sed 's/varwww//g') 
    echo "\n✨   CREATING BACKUP FOR $SITE \n"
    ./scripts/backup.sh $SITE
    sudo rm -rf ./process/${SITE}.running
    echo "\n✨   BACKUP FOR $SITE FINISHED \n"
done
echo '\n✨   ZIPPING BACKUP\n'
cd $HOME
zip -r $ZIP_NAME backup

echo '\n✨   UPLOADING TO AWS\n'
aws s3 cp $ZIP_NAME s3://$BUCKET_NAME

echo '\n✨   CLEANING OLDER BACKUPS\n'
./scripts/clear-backups.sh $BUCKET_NAME

echo '\n✨   CLEANING BACKUP\n'
sudo rm -rf backup
sudo rm -rf $ZIP_NAME

echo '\n✅   BACKUP DONE\n'