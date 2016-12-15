#!/bin/bash
if [ ! $SERVER_IP ]
then
       IP=$(ip a s|grep brd |grep 'inet '|egrep -o '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | head -1)
       ROOT_PASSWORD=passwd
       SERVER_IP=$IP
       IFS=. read -r a b c d <<< $IP
       DHCP_SUBNET=$a.$b.$c.0
       DHCP_ROUTER=$a.$b.$c.5
       DHCP_DNS=$a.$b.$c.1
       DHCP_RANGE="$a.$b.$c.100 $a.$b.$c.150"
fi

if [ `grep 127.0.0.1 /etc/cobbler/settings | wc -l` -gt 1 ]
then
        PASSWORD=`openssl passwd -1 -salt hLGoLIZR $ROOT_PASSWORD`
        sed -i "s/^server: 127.0.0.1/server: $SERVER_IP/g" /etc/cobbler/settings
        sed -i "s/^next_server: 127.0.0.1/next_server: $SERVER_IP/g" /etc/cobbler/settings
        sed -i 's/pxe_just_once: 0/pxe_just_once: 1/g' /etc/cobbler/settings
        sed -i "s#^default_password.*#default_password_crypted: \"$PASSWORD\"#g" /etc/cobbler/settings
        sed -i "s/192.168.1.0/$DHCP_SUBNET/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.5/$DHCP_ROUTER/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.1;/$DHCP_DNS;/" /etc/cobbler/dhcp.template
        sed -i "s/192.168.1.100 192.168.1.254/$DHCP_RANGE/" /etc/cobbler/dhcp.template
fi

service cobblerd start
service httpd start
#cobbler sync > /dev/null 2>&1
cobbler sync
