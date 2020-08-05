#!/bin/bash

set -e

# default to 1am schedule
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
SERVICE_NAME=${SERVICE_NAME}
BACKUPPER_URL=${BACKUPPER_URL}
TOKEN_SECRET=${TOKEN_SECRET}
DB_URL=${DB_URL}

LOGFIFO='/var/log/cron.fifo'
if [[ ! -e "$LOGFIFO" ]]; then
    mkfifo "$LOGFIFO"
fi
CRON_ENV="SERVICE_NAME='$SERVICE_NAME'\nDB_URL='$DB_URL'\nBACKUPPER_URL='$BACKUPPER_URL'\nTOKEN_SECRET='${TOKEN_SECRET}'"

echo -e "$CRON_ENV\n$CRON_SCHEDULE /dump.sh > $LOGFIFO 2>&1" | crontab -
crontab -l
cron
tail -f "$LOGFIFO"
