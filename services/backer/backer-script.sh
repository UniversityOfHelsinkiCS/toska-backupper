#!/bin/bash

set -e

echo "Backup process started $(date)"
echo $DB_NAME
DATE=$(date +%Y%m%d_%H%M%S)

docker exec $DB_NAME pg_dump -U postgres > ./$DB_NAME_$DATE_backupper.dump

curl -F file=@$DB_NAME_$DATE_backupper.dump $BACKUPPER_URL/$DB_NAME/$DATE_backupper.dump\?token\=$TOKEN_SECRET

rm $BACKUP_LOCATION_$DATE_backupper.dump

echo "Backup process ended $(date)"

