#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/$SERVICE_NAME-$DATE.sql"
COMPRESSED_FILE="$FILE.gz"
HASH_STORAGE_FILE="PREVIOUS_HASH.txt"
pg_dump $DB_URL -f "$FILE" # Compress later because compression causes the hash to always change.
NEW_BACKUP_HASH=$(sha256sum $FILE | cut -d " " -f 1)

if test -f "$HASH_STORAGE_FILE";
    then
    PREVIOUS_BACKUP_HASH=$(<$HASH_STORAGE_FILE)
    
    if [ "$PREVIOUS_BACKUP_HASH" = "$NEW_BACKUP_HASH" ];
        then
        echo "Hashes are equal ($PREVIOUS_BACKUP_HASH vs. $NEW_BACKUP_HASH), skipping upload"
    else
        echo "Hashes differ ($PREVIOUS_BACKUP_HASH vs. $NEW_BACKUP_HASH), uploading new dump"
        gzip $FILE
        curl -w "\n" -F file=@$COMPRESSED_FILE $BACKUPPER_URL/backups/$SERVICE_NAME/$COMPRESSED_FILE\?token\=$TOKEN_SECRET
    fi
else
  echo "Previous backup hash unknown, uploading new dump"
  gzip $FILE
  curl -w "\n" -F file=@$COMPRESSED_FILE $BACKUPPER_URL/backups/$SERVICE_NAME/$COMPRESSED_FILE\?token\=$TOKEN_SECRET
fi

echo $NEW_BACKUP_HASH > $HASH_STORAGE_FILE

if [ "$PERSIST_LOCAL_BACKUPS" != "true" ]
then
  rm -f $FILE $COMPRESSED_FILE
fi

echo "Job finished: $(date)"
