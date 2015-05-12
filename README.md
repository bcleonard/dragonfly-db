# dragonfly-db
This is the docker files for building the dragonfly database container.

You'll need to create a local filesystem to hold the persistant database.
I recommend /data/mysql

To start the container:

docker run -d -p 3306:3306 -v /data/mysql:/var/lib/mysql dragonfly-db

To test the container:

mysql -u admin -p -h 127.0.0.1 (from the host running the container)

