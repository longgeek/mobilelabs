#!/bin/bash
# Author: Longgeek <longgeek@gmail.com>

source ~/user-env.sh > /dev/null 2>&1

if [ "$?" -ne '0' ]; then
    echo "\nThe '~/user-env.sh' file was not found, Please run the launch_instances.py file.\n"
    exit 1
fi

which nova > /dev/null 2>&1

if [ "$?" -ne '0' ]; then
    echo -e '\nThe Nova command was not found, Please install the nova-pythonclient package.()\n'
    exit 1
fi

which sshpass > /dev/null 2>&1

if [ "$?" -ne '0' ]; then
    echo -e '\nThe sshpass command was not found, Please install the sshpass source package.(http://colocrossing.dl.sourceforge.net/project/sshpass/sshpass/1.05/sshpass-1.05.tar.gz)\n'
    exit 1
fi
echo -e "\n$(date) Start Check...\n" | tee -a ~/instance-result.log
echo '+----------------+---------------+-----------+-------------------------------+' | tee -a ~/instance-result.log
echo '| VM-IP          | PING-RESULT   | SSH-KEY   | SSH-PASS   | HOSTNAME-MATCH   |' | tee -a ~/instance-result.log
echo '+----------------+---------------+-----------+-------------------------------+' | tee -a ~/instance-result.log

CONN_COMMAND="ip net exec qdhcp-$INSTANCE_NETWORK"
# Get to the user vm
INSTANCE_IP=$(nova list | \
              awk -F 'inter=' '{print $2}' | \
              awk '{print $1}' | grep -v ^$ | \
              sort -t '.' -k1,1n  -k2,2n  -k3,3n  -k4,4n
             )


for IP in $INSTANCE_IP
do
    $CONN_COMMAND ping -c 2 $IP > /dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        PING_RESULT=':-)'
    else
        PING_RESULT='xxx'
    fi
    [ -e ~/.ssh/id_rsa ] || mv ~/.ssh/id_rsa.check.mv ~/.ssh/id_rsa || exit 1
    [ $($CONN_COMMAND ssh -o StrictHostKeyChecking=no root@$IP hostname) = $(nova list | grep $IP | awk '{print $4}') ] > /dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        SSH_KEY=':-)'
        HOSTNAME_MATCH=':-)'
    else
        SSH_KEY='xxx'
        HOSTNAME_MATCH='xxx'
    fi

    [ -e ~/.ssh/id_rsa ] && mv ~/.ssh/id_rsa ~/.ssh/id_rsa.check.mv
    [ $($CONN_COMMAND sshpass -p $INSTANCE_PASSWORD ssh -o StrictHostKeyChecking=no root@$IP hostname 2> /dev/null) = $(nova list | grep $IP | awk '{print $4}') ] > /dev/null 2>&1
    if [ "$?" -eq "0" ]; then
        SSH_PASS=':-)'
        HOSTNAME_MATCH=':-)'
    else
        SSH_PASS='xxx'
        HOSTNAME_MATCH='xxx'
    fi
    echo "| $IP     | $PING_RESULT           | $SSH_KEY       | $SSH_PASS        | $HOSTNAME_MATCH              |" | tee -a ~/instance-result.log

done
echo '+----------------+---------------+-----------+-------------------------------+' | tee -a ~/instance-result.log
