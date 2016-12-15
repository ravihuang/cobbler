FROM centos:6
MAINTAINER Ravi Huang <ravi.huang@gmail.com>

RUN yum -y install curl epel-release pykickstart dhcp
RUN yum -y install cobbler cobbler-web cman debmirror && yum update -y --enablerepo=epel-testing cobbler && \
    sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/tftp && \
    sed -i -e 's/\(^.*disable.*=\) yes/\1 no/' /etc/xinetd.d/rsync && \
    sed -i -e 's/@dists=/dists=/' /etc/debmirror.conf && \
    sed -i -e 's/@arches=/arches=/' /etc/debmirror.conf && \
    sed -i -e 's/manage_dhcp: 0/manage_dhcp: 1/' /etc/cobbler/settings && \
    (echo -n "cobbler:Cobbler:" && echo -n "cobbler:Cobbler:passwd" | md5sum | awk '{print $1}' ) >/etc/cobbler/users.digest && \
    rm -f /var/lib/cobbler/loaders/* && yum clean all 

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

EXPOSE 25151
EXPOSE 69/udp
EXPOSE 80
EXPOSE 443

