#!/bin/bash
# Author: Longgeek <longgeek@gmail.com>

clear
echo "\n"
echo '#########################'
echo 'Note: Update nameservers!'
echo '#########################'
echo "\n"
exit 0

cobbler system  add \
--name=control1 \
--hostname=control1 \
--dns-name=control1.pxe.com \
--profile=RHEL-6.5-x86_64 \
--interface=eth0 \
--mac=08:00:27:00:00:00 \
--ip-address=192.168.3.40 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers='192.168.3.60 114.114.114.114' \
--static=1

cobbler system  add \
--name=network1 \
--hostname=network1 \
--dns-name=network1.pxe.com \
--profile=RHEL-6.5-x86_64 \
--interface=eth0 \
--mac=08:00:27:10:10:10 \
--ip-address=192.168.3.41 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers='192.168.3.60 114.114.114.114' \
--static=1

cobbler system  add \
--name=compute1 \
--hostname=compute1 \
--dns-name=compute1.pxe.com \
--profile=RHEL-6.5-x86_64 \
--interface=eth0 \
--mac=08:00:27:20:20:20 \
--ip-address=192.168.3.42 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers='192.168.3.60 114.114.114.114' \
--static=1

#--power-type=ipmilan \
#--power-user=root \
#--power-pass=superuser \
#--power-address=172.18.200.13

cobbler system edit \
--name=control1 \
--interface=eth1 \
--mac=08:00:27:00:00:01 \
--ip-address=172.16.0.40 \
--subnet=255.255.0.0 \
--static=1

cobbler system edit \
--name=network1 \
--interface=eth1 \
--mac=08:00:27:10:10:11 \
--ip-address=172.16.0.41 \
--subnet=255.255.0.0 \
--static=1

cobbler system edit \
--name=compute1 \
--interface=eth1 \
--mac=08:00:27:20:20:21 \
--ip-address=172.16.0.42 \
--subnet=255.255.0.0 \
--static=1

cobbler sync
