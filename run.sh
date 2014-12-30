#!/bin/bash

#change the password and template1 if requested.
service postgresql start >/dev/null 2>&1
if [ ! -f /.postgres_pass_modified ]; then
	/modify_postgres_pass.sh
	/modify_postgres_template1.sh
fi
service postgresql stop >/dev/null 2>&1

#start PostgreSQL
sudo -u postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf 
