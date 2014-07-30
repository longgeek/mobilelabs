class glance::iptables {
    exec { '9191':
        command => 'iptables -I INPUT 1 -p tcp --dport 9191 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9191 -j ACCEPT' /etc/sysconfig/iptables",
    }

    exec { '9292':
        command => 'iptables -I INPUT 1 -p tcp --dport 9292 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9292 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['9191'],
    }
}
