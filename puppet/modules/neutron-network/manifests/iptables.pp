class neutron-network::iptables {
    exec { '9697':
        command => 'iptables -I INPUT 1 -p tcp --dport 9697 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '9697 -j ACCEPT' /etc/sysconfig/iptables",
    }

    exec { '67':
        command => 'iptables -A INPUT -p udp -m multiport --dports 67 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '\--dports 67 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['9697'],
    }

    exec { '68':
        command => 'iptables -A OUTPUT -p udp -m multiport --dports 68 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '\--dports 68 -j ACCEPT' /etc/sysconfig/iptables",
        require => Exec['67'],
    }
}
