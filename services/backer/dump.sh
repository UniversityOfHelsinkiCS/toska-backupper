#!/bin/bash

set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/$SERVICE_NAME-$DATE.sql"

pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -f "$FILE" -d "$PGDB" 

curl -F file=@$FILE $BACKUPPER_URL/$SERVICE_NAME/$FILE\?token\=$TOKEN_SECRET

rm $FILE

echo "Job finished: $(date)"