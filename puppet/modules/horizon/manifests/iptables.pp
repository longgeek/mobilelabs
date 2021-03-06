class horizon::iptables {
    exec { '80':
        command => 'iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '80 -j ACCEPT' /etc/sysconfig/iptables | grep -v 6080",
    }

    exec { '11211':
        command => 'iptables -I INPUT 1 -p tcp --dport 11211 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '11211 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['80'],
    }
}
