class keystone::iptables {
    exec { '5000':
        command => 'iptables -I INPUT 5 -p tcp --dport 5000 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '5000 -j ACCEPT' /etc/sysconfig/iptables",
        notify  => Exec['35357'],
    }

    exec { '35357':
        command => 'iptables -I INPUT 5 -p tcp --dport 35357 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '35357 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
