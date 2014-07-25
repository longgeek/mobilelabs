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
--name=control \
--hostname=control \
--dns-name=control.pxe.com \
--profile=RHEL-6.5-x86_64 \
--interface=eth0 \
--mac=08:00:27:8D:9E:49 \
--ip-address=192.168.3.40 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers='192.168.3.60 114.114.114.114' \
--static=1

cobbler system  add \
--name=network \
--hostname=network \
--dns-name=network.pxe.com \
--profile=RHEL-6.5-x86_64 \
--interface=eth0 \
--mac=08:00:27:2E:91:59 \
--ip-address=192.168.3.41 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers='192.168.3.60 114.114.114.114' \
--static=1

cobbler system  add \
--name=compute \
--hostname=compute \
--dns-name=compute.pxe.com \
--profile=RHEL-6.5-x86_64 \
--interface=eth0 \
--mac=08:00:27:C2:CC:E5 \
--ip-address=192.168.3.42 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers='192.168.3.60 114.114.114.114' \
--static=1

#--power-type=ipmilan \
#--power-user=root \
#--power-pass=superuser \
#--power-address=172.18.200.13

#cobbler system edit \
#--name=node13 \
#--interface=eth1 \
#--mac=00:e0:81:de:20:9f \
#--ip-address=10.200.1.13 \
#--subnet=255.255.0.0 \
#--static=1
cobbler sync
