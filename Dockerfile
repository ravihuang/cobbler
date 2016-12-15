FROM centos:6
MAINTAINER Ravi Huang <ravi.huang@gmail.com>

ADD start.sh /start.sh

RUN yum -y install curl epel-release pykickstart dnsmasq && chmod +x /start.sh
RUN yum -y install cobbler cobbler-web cman debmirror && yum update -y --enablerepo=epel-testing cobbler && \
    sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/tftp && \
    sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/rsync && \
    sed -i -e 's/@dists=/dists=/' /etc/debmirror.conf && \
    sed -i -e 's/@arches=/arches=/' /etc/debmirror.conf && \
    sed -i -e 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings && \
    sed -i -e 's/module = manage_isc/module = manage_dnsmasq/' /etc/cobbler/modules.conf && \
    echo "user=root" >> /etc/dnsmasq.conf && \
    yum clean all 

#RUN service cobblerd start && cobblerd get-loaders && service cobblerd stop
#RUN curl -O http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/Debian_8.0/cobbler_2.8.0.orig.tar.gz && tar xzvf cobbler_2.8.0.orig.tar.gz
#RUN cd cobbler-2.8.0 && python setup.py install

CMD ["/start.sh"]

EXPOSE 25151
EXPOSE 69/udp
EXPOSE 80
EXPOSE 443

