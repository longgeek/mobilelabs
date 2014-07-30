class neutron-network::iptables {
    exec { '9697':
        command => 'iptables -I INPUT 1 -p tcp --dport 9697 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9697 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
