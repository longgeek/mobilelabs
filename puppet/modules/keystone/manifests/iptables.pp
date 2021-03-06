class keystone::iptables {
    exec { '5000':
        command => 'iptables -I INPUT 1 -p tcp --dport 5000 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '5000 -j ACCEPT' /etc/sysconfig/iptables",
    }

    exec { '35357':
        command => 'iptables -I INPUT 1 -p tcp --dport 35357 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '35357 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['5000'],
    }
}
