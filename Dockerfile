FROM ubuntu:trusty
MAINTAINER Bradley Leonard <bradley@stygianresearch.com>

#
# install all updates and software needed
# 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update &&\
 apt-get -y install mysql-server &&\
 apt-get -y install wget &&\
 apt-get -y install unzip

#
# update bind-address
#
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

#
# download and unzip the dragonfly code
#
ENV URL=https://github.com/FlatBallFlyer/IBM-Data-Merge-Utility/archive/master.zip
RUN cd /tmp &&\
  wget $URL &&\
  unzip master.zip &&\
  rm /tmp/master.zip

#
# add the start up script
# 
ADD ./startup.sh /opt/startup.sh

EXPOSE 3306

CMD ["/bin/bash", "/opt/startup.sh"]

