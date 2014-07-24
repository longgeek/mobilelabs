class glance::iptables {
    exec { '9191':
        command => 'iptables -I INPUT 5 -p tcp --dport 9191 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9191 -j ACCEPT' /etc/sysconfig/iptables",
        notify  => Exec['9292'],
    }

    exec { '9292':
        command => 'iptables -I INPUT 5 -p tcp --dport 9292 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9292 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
