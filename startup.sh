#!/bin/bash

MYSQL_ROOTPASSWD=changeme

#
# if the default database is missing (usually means first run), create it
#
if [ ! -f /var/lib/mysql/ibdata1 ]
then
  /usr/bin/mysql_install_db

  /usr/libexec/mysqld &
  sleep 10s
  echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY '$MYSQL_ROOTPASSWD' WITH GRANT OPTION; FLUSH PRIVILEGES" | /usr/bin/mysql

  killall mysqld
  sleep 10s
fi

#
# if the dragonfly template database is missing (usually means first run), create it
#
if [ ! -f /var/lib/mysql/dragonfly ]
then

  /usr/libexec/mysqld &
  sleep 10s

  /usr/bin/mysql -u admin -p$MYSQL_ROOTPASSWD < /tmp/TESTDB.SQL

  killall mysqld
  sleep 10s
fi

#
# start mysqld
#
/usr/bin/mysqld_safe

