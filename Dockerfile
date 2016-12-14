FROM ubuntu:16.04
MAINTAINER Ravi Huang <ravi.huang@gmail.com>

ADD start.sh /start.sh

RUN apt-get -q update && apt-get -qy install curl cobbler cobbler-web && chmod +x /start.sh

RUN curl -O http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/Debian_8.0/cobbler_2.8.0.orig.tar.gz && tar xzvf cobbler_2.8.0.orig.tar.gz
RUN cd cobbler-2.8.0 && python setup.py install

#CMD ["/start.sh"]

EXPOSE 25151
EXPOSE 69/udp
EXPOSE 80
EXPOSE 443

