#!/bin/bash

set -e

# default to 1am schedule
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
PGUSER=${PGUSER:-postgres}
PGDB=${PGDB:-postgres}
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}

LOGFIFO='/var/log/cron.fifo'
if [[ ! -e "$LOGFIFO" ]]; then
    mkfifo "$LOGFIFO"
fi
CRON_ENV="PREFIX='$SERVICE_NAME'\nPGUSER='$PGUSER'\nPGDB='$PGDB'\nPGHOST='$PGHOST'\nPGPORT='$PGPORT'"

echo -e "$CRON_ENV\n$CRON_SCHEDULE /dump.sh > $LOGFIFO 2>&1" | crontab -
crontab -l
cron
tail -f "$LOGFIFO"
