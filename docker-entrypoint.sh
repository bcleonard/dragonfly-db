#!/bin/bash -x
set -e

MYSQL_ROOT_PASSWORD="idrawssap"
MYSQL_DATABASE="dragonfly"
MYSQL_USER="dragonfly"
MYSQL_PASSWORD="idrawssap"
TEST_SQL="/tmp/TESTDB.SQL"

if [ "${1:0:1}" = '-' ]
then
  set -- mysqld_safe "$@"
fi

if [ "$1" = 'mysqld_safe' ]
then
	DATADIR="/var/lib/mysql"
	
	if [ ! -d "$DATADIR/mysql" ]; then
		if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and MYSQL_ROOT_PASSWORD not set'
			echo >&2 '  Did you forget to add -e MYSQL_ROOT_PASSWORD=... ?'
			exit 1
		fi
		
		echo 'Running mysql_install_db ...'
		mysql_install_db --datadir="$DATADIR"
		echo 'Finished mysql_install_db'
		
		# These statements _must_ be on individual lines, and _must_ end with
		# semicolons (no line breaks or comments are permitted).
		# TODO proper SQL escaping on ALL the things D:
		
		tempSqlFile='/tmp/mysql-first-time.sql'
		cat > "$tempSqlFile" <<-EOSQL
			DELETE FROM mysql.user ;
			CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
			GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
			DROP DATABASE IF EXISTS test ;
		EOSQL
		
		if [ "$MYSQL_DATABASE" ]; then
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" >> "$tempSqlFile"
		fi
		
		if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]
                then
		  echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> "$tempSqlFile"
			
		  if [ "$MYSQL_DATABASE" ]
                  then
	   	    echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" >> "$tempSqlFile"

                    if [ -f "${TEST_SQL}" ]
                    then
                      cat ${TEST_SQL} >> "$tempSqlFile"
                    fi
		  fi
		fi
		
		echo 'FLUSH PRIVILEGES ;' >> "$tempSqlFile"
		
		set -- "$@" --init-file="$tempSqlFile"
	fi
	
	chown -R mysql:mysql "$DATADIR"
fi

exec "$@"

