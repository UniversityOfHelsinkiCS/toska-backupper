#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/$SERVICE_NAME-$DATE.sql"

pg_dump $DB_URL -f "$FILE"

curl -F file=@$FILE $BACKUPPER_URL/backups/$SERVICE_NAME/$FILE\?token\=$TOKEN_SECRET


if [ $REMOVE_LOCAL_FILE_AFTER_BACKUP = "true" ]
then
  rm $FILE
fi

echo "Job finished: $(date)"
