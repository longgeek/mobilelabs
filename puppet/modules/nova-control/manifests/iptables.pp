class nova-control::iptables {
    exec { '8773':
        command => 'iptables -I INPUT 5 -p tcp --dport 8773 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '8773 -j ACCEPT' /etc/sysconfig/iptables",
        notify  => Exec['8774'],
    }

    exec { '8774':
        command => 'iptables -I INPUT 5 -p tcp --dport 8774 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '8774 -j ACCEPT' /etc/sysconfig/iptables",
        notify  => Exec['8775'],
    }

    exec { '8775':
        command => 'iptables -I INPUT 5 -p tcp --dport 8775 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '8775 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
