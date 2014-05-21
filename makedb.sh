#!/bin/bash

# Simple database creation script, hardly saves you any time at all, adds to your lazyness. Intended for use in dev environments.
# Usage: "makedb.sh <database>" eg. makedb.sh wordpress_blog

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 DB_NAME" >&2
  exit 1
fi

DB_USER=''
DB_PASS=''
DB=$1

if [ -z $DB_USER ] || [ -z $DB_PASS ]; then
  echo 'ERROR: username or password not set'
  exit 1
fi

$(echo 'exit' | mysql -u$DB_USER -p$DB_PASS 2>/dev/null)
if [ $? != 0  ]; then
  echo 'ERROR: mysql credentials do not seem to be valid...'
  exit 1
fi

$(echo "create database $DB" | mysql -u$DB_USER -p$DB_PASS)
