# dragonfly-db

dragonfly-db the container of the dragonfly application's test database (IBM Data Merge Utility).  Go [here](http://www.ssgpp.com/dragonflyhome) more information on the [dragonfly project](http://www.ssgpp.com/dragonflyhome).

### Persistant database
If you would like the database to be persistant, I recommend creating a local filesystem.  I used
```sh
/data/dragonflydb
```
for the instuctrions below.  Just make sure you create it prior to starting the container.

### To start the container:
```sh
docker run -t -i -p 3306:3306 -v /data/dragonflydb:/var/lib/mysql dragonfly-db
```
### To verify the testgen database has the correct tables, run:
```sh
mysql --user=root --password=drawssap -h 127.0.0.1 -e 'use testgen;show tables;'
```
from the container host.  You should see the following message:

|Tables_in_testgen|
|------------------|
| CONTACT |
| CORPORATE |
| CUSTOMER |

