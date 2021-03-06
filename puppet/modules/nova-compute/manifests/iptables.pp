class nova-compute::iptables {
    exec { 'tcp 53':
        command => 'iptables -I INPUT 1 -p tcp --dport 53 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep 'tcp --dport 53 -j ACCEPT' /etc/sysconfig/iptables",
    }

    exec { 'udp 53':
        command => 'iptables -I INPUT 1 -p udp --dport 53 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep 'udp --dport 53 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['tcp 53'],
    }

    exec { '5900:6400':
        command => "iptables -I INPUT 1 -p tcp -s $nova_host --dport 5900:6400 -j ACCEPT; \
                    /etc/init.d/iptables save",
        path    => $command_path,
        unless  => "grep 'tcp --dport 5900:6400 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['udp 53'],
    }
}
