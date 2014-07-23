#!/bin/bash

TOP_DIR=$(cd $(dirname "$0") && pwd)
DVD1_NAME=$(file /opt/*.iso | grep 'CentOS_6.[4]' | grep bootable | awk -F: '{print $1}' | awk -F/ '{print $3}')
DVD2_NAME=$(file /opt/*.iso | grep 'CentOS_6.[4]' | grep -v bootable | awk -F: '{print $1}' | awk -F/ '{print $3}')
ISO_TYPE='CentOS-6.4'
IPADDR=$(ifconfig | grep 'inet addr:' | grep -v 127.0.0.1 | awk -F: '{print $2}' | awk '{print $1}')
PASSWD=$(openssl passwd -1 -salt 'random-phrase-here' 'password')
CHECK_HOSTNAME=$(hostname | awk -F. '{print $3}')
COBBLER_CONFIG='/etc/cobbler/settings'

if [ "$DVD1_NAME" = '' ]; then
    echo 'Error: Centos dvd1 ISO file was not found in the /opt/ directory!'
    exit 1
fi

if [ "$DVD2_NAME" = '' ]; then
    echo 'Error: Centos dvd2 ISO file was not found in the /opt/ directory!'
    exit 1
fi

if [ "$CHECK_HOSTNAME" = '' ]; then
    echo 'Error: The host name is not FQDN, please set!'
    exit 1
fi

### Iptables ###
iptables -F
iptables -t nat -F
/etc/init.d/iptables save
/etc/init.d/iptables stop
chkconfig iptables off
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf

### Yum ###
[ -e /var/www/cobbler/repo_mirror ] || mkdir -p /var/www/cobbler/repo_mirror
[ -z /var/www/cobbler/repo_mirror ] || rm -fr /var/www/cobbler/repo_mirror/*
cp -rf $TOP_DIR/*-requirements /var/www/cobbler/repo_mirror/
[ -e /repo/dvd1 ] || mkdir -p /repo/{dvd1,dvd2}
umount /opt/$DVD1_NAME > /dev/null 2>&1
mount -t auto -o loop /opt/$DVD1_NAME /repo/dvd1
[ -e /etc/yum.repos.d/backup ] || mkdir /etc/yum.repos.d/backup
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup
cat > /etc/yum.repos.d/local.repo << _Longgeek_
[dvd]
name=dvd repo
baseurl=file:///repo/dvd1
gpgcheck=0
priority=1

[local]
name=local repo
baseurl=file:///var/www/cobbler/repo_mirror/rpm-requirements
gpgcheck=0
priority=1
_Longgeek_
yum clean all
yum update

### Install Cobbler ###
yum -y install cman ntp tftp tftp-server xinetd cobbler cobbler-web httpd pykickstart dnsmasq puppet-server
/etc/init.d/cobblerd restart
/etc/init.d/httpd restart

sed -i '/disable.*$/ s/yes/no/g' /etc/xinetd.d/tftp
sed -i '/disable.*$/ s/yes/no/g' /etc/xinetd.d/rsync
sed -i 's/= manage_isc/= manage_dnsmasq/g' /etc/cobbler/modules.conf
sed -i 's/= manage_bind/= manage_dnsmasq/g' /etc/cobbler/modules.conf

[ -e $COBBLER_CONFIG.backup ] || cp $COBBLER_CONFIG $COBBLER_CONFIG.backup
sed -i 's/^[[:space:]]\+/ /' $COBBLER_CONFIG
sed -i 's/allow_dynamic_settings: 0/allow_dynamic_settings: 1/g' $COBBLER_CONFIG
/etc/init.d/cobblerd restart

cobbler setting edit --name=pxe_just_once --value=1
cobbler setting edit --name=server --value=$IPADDR
cobbler setting edit --name=next_server --value=$IPADDR
cobbler setting edit --name=manage_rsync --value=1
cobbler setting edit --name=manage_dhcp --value=1
cobbler setting edit --name=manage_dns --value=1
cobbler setting edit --name=puppet_server --value=$HOSTNAME
sed -i "s/^default_password_crypted:.*$/default_password_crypted: '"$PASSWD"'/g" $COBBLER_CONFIG
cp -f $TOP_DIR/default.ks /var/lib/cobbler/kickstarts/

### Cobbler Web ###
sed -i 's/authn_denyall/authn_configfile/g' /etc/cobbler/modules.conf
echo "cobbler:Cobbler:a2d6bae81669d707b72c0bd9806e01f3" > /etc/cobbler/users.digest

### NTP ###
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
grep $IPADDR /etc/ntp.conf ||
echo "server $IPADDR
server 127.127.1.0
fudge 127.127.1.0 stratum 10" >> /etc/ntp.conf
/etc/init.d/ntpd restart

cat > /etc/cobbler/dnsmasq.template << _Longgeek_
# Cobbler generated configuration file for dnsmasq
# \$date
#

# resolve.conf .. ?
#no-poll
#enable-dbus
read-ethers
addn-hosts = /var/lib/cobbler/cobbler_hosts

dhcp-range=$(echo $IPADDR | awk -F. '{print $1"."$2"."$3}').0,static
dhcp-ignore=tag:!known
dhcp-ignore=#known
no-dhcp-interface=eth1,eth2,eth3
server=\$next_server
dhcp-option=3,\$next_server
dhcp-lease-max=1000
dhcp-authoritative
dhcp-boot=pxelinux.0
dhcp-boot=net:normalarch,pxelinux.0
dhcp-boot=net:ia64,\$elilo

\$insert_cobbler_system_definitions
_Longgeek_

rm -fr /var/www/cobbler/ks_mirror/$ISO_TYPE-x86_64
if [ $(cobbler system list | wc -l) != '0' ]; then
    for system in $(cobbler system list)
    do
        cobbler system remove --name=$system
    done
fi
if [ $(cobbler profile list | wc -l) != '0' ]; then
    for system in $(cobbler profile list)
    do
        cobbler profile remove --name=$system
    done
fi
if [ $(cobbler distro list | wc -l) != '0' ]; then
    for system in $(cobbler distro list)
    do
        cobbler distro remove --name=$system
    done
fi
cobbler import --path=/repo/dvd1 --name=$ISO_TYPE --arch=x86_64
cobbler profile edit --name $ISO_TYPE-x86_64 --kickstart=/var/lib/cobbler/kickstarts/default.ks
cat > /etc/yum.repos.d/local.repo << _Longgeek_
[dvd]
name=dvd repo
baseurl=file:///var/www/cobbler/ks_mirror/$ISO_TYPE-x86_64
gpgcheck=0
priority=1

[local]
name=local repo
baseurl=file:///var/www/cobbler/repo_mirror/rpm-requirements
gpgcheck=0
priority=1
_Longgeek_

if [ "$DVD2_NAME" != '' ]; then
    mount -t auto -o loop /opt/$DVD2_NAME /repo/dvd2
    alias cp='cp'
    cp -rf /repo/dvd2/Packages/ /var/www/cobbler/ks_mirror/$ISO_TYPE-x86_64/
    cd /var/www/cobbler/ks_mirror/$ISO_TYPE-x86_64/
    createrepo -g repodata/*-comps.xml .
fi

yum clean all
yum update

### Puppet ###
rm -fr /etc/puppet
cp -r puppet /etc/

### SSH ###
sed -i "s/#UseDNS yes/UseDNS no/"  /etc/ssh/sshd_config
echo 'StrictHostKeyChecking  no' >> etc/ssh/ssh_config
sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
rm -fr ~/.ssh/*
sh-keygen  -t rsa -f ~/.ssh/id_rsa  -N ''
rm -f /etc/puppet/files/bases/id_rsa*
cp /root/.ssh/id_rsa* /etc/puppet/files/bases/
chmod 755 /etc/puppet/files/bases/id_rsa

cobbler sync
echo '*' > /etc/puppet/autosign.conf
chkconfig ntpd on
chkconfig httpd on
chkconfig xinetd on
chkconfig dnsmasq on
chkconfig cobblerd on
chkconfig puppetmaster on
/etc/init.d/sshd restart
/etc/init.d/httpd restart
/etc/init.d/xinetd restart
/etc/init.d/dnsmasq restart
/etc/init.d/cobblerd restart
/etc/init.d/puppetmaster restart
