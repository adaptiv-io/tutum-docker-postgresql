#!/bin/bash


if [ -z "$PG_ENCODING" ]; then
  echo "PG_ENCODING is not set, using postgres default template1 encoding, collation, cytpe"
  exit 0
# we want to change some settings with template1
else
  # make template1 not a template
  sudo -u postgres psql -U postgres -d postgres -c "UPDATE pg_database SET datistemplate='false' WHERE datname='template1';"
  # drop template1
  sudo -u postgres psql -U postgres -d postgres -c "DROP DATABASE IF EXISTS template1;"
  # checking for collation, ctype
  if [ -z "$PG_COLLATE" ] && [ -z "$PG_CTYPE" ]; then
    echo 'you did not specify a collate or ctype, assuming default'
    sudo -u postgres psql -U postgres -d postgres -c "create database template1 with template = template0 encoding = '$PG_ENCODING';"
  else
    # we wish to install and set encoding, colate, ctype
    echo "need to install locale: $PG_COLLATE"
    apt-get update
    apt-get install -y language-pack-$(echo "$PG_COLLATE" | cut -d\_ -f1)
    export LANG=$PG_COLLATE
    echo "creating template1 with encoding: $PG_ENCODING , LC_COLLATE: $PG_COLLATE , LC_CTYPE: $PG_CTYPE"
    sudo -u postgres psql -U postgres -d postgres -c "create database template1 with template = template0 encoding = '$PG_ENCODING' LC_CTYPE = '$PG_CTYPE' LC_COLLATE = '$PG_COLLATE';"
  fi
fi
