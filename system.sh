#!/bin/bash
# Author: Longgeek <longgeek@gmail.com>
cobbler system  add \
--name=node1 \
--hostname=node1 \
--dns-name=node1.pxe.com \
--profile=CentOS-6.4-x86_64 \
--interface=eth0 \
--mac=08:00:27:C0:32:CF \
--ip-address=192.168.3.30 \
--subnet=255.255.255.0 \
--gateway=192.168.3.254 \
--name-servers=192.168.3.232 \
--static=1 \
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
