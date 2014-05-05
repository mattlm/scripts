#!/bin/bash

# Simple database dumping script intended for use in development environments.
# Usage: "dbdump.sh <database>" eg. dbbump.sh wordpress_blog
# The default output location is your home directory.
# The default output file name is YYYYMMDD-HHMM_database_name.sql.gz
# To easily use the resulting dump: zcat YYYYMMDD-HHMM_database_name.sql.gz | mysql -uUSER -pPASS database_name

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 DB_NAME" >&2
  exit 1
fi

DB_USER=''
DB_PASS=''
DB=$1
DUMP_DIR=$HOME'/'
DUMP_NAME=$(date +%Y%m%d)-$(date +%H%M)_$DB'.sql.gz'
DUMP_PATH=$DUMP_DIR$DUMP_NAME

if [ -z $DB_USER ] || [ -z $DB_PASS ]; then
  echo 'ERROR: username or password not set'
  exit 1
fi

$(echo 'exit' | mysql -u$DB_USER -p$DB_PASS 2>/dev/null)
if [ $? != 0  ]; then
  echo 'ERROR: mysql credentials do not seem to be valid...'
  exit 1
fi

echo "dumping ${DB} to ${DUMP_PATH}"

$(mysqldump -u$DB_USER -p$DB_PASS $DB | gzip > $DUMP_PATH)

echo "done"
