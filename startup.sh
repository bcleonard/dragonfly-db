#!/bin/bash

MYSQL_ROOTPASSWD=changeme

#
# if the default database is missing (usually means first run), create it
#
if [ ! -f /var/lib/mysql/ibdata1 ]
then
  mysql_install_db

  /usr/sbin/mysqld &
  sleep 10s
  echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY '$MYSQL_ROOTPASSWD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

  killall mysqld
  sleep 10s
fi

#
# if the dragonfly template database is missing (usually means first run), create it
#
if [ ! -f /var/lib/mysql/dragonfly ]
then

  /usr/sbin/mysqld &
  sleep 10s

  mysql -u admin -p$MYSQL_ROOTPASSWD < /tmp/IBM-Data-Merge-Utility-master/WebContent/sql/createTemplateDatabase.sql

  killall mysqld
  sleep 10s
fi

#
# start mysqld
#
/usr/bin/mysqld_safe

