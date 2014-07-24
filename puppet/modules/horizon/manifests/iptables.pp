class horizon::iptables {
    exec { '80':
        command => 'iptables -I INPUT 5 -p tcp --dport 80 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '80 -j ACCEPT' /etc/sysconfig/iptables",
        notify  => Exec['11211'],
    }

    exec { '11211':
        command => 'iptables -I INPUT 5 -p tcp --dport 11211 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '11211 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
