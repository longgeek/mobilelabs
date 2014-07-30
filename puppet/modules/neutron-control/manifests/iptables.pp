class neutron-control::iptables {
    exec { '9696':
        command => 'iptables -I INPUT 1 -p tcp --dport 9696 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9696 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
