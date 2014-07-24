class mysql::iptables {
    exec { '3306':
        command => 'iptables -I INPUT 5 -p tcp --dport 3306 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '3306 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
