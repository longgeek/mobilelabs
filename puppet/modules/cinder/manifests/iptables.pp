class cinder::iptables {
    exec { '8776':
        command => 'iptables -I INPUT 5 -p tcp --dport 8776 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '8776 -j ACCEPT' /etc/sysconfig/iptables",
    }

    exec { '3260':
        command => 'iptables -I INPUT 5 -p tcp --dport 3260 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '3260 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
