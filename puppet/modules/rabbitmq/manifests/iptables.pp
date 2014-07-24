class rabbitmq::iptables {
    exec { '5672':
        command => 'iptables -I INPUT 5 -p tcp --dport 5672 -j ACCEPT; \
                    /etc/init.d/iptables save',
        path    => $command_path,
        unless  => "grep '5672 -j ACCEPT' /etc/sysconfig/iptables",
    }
}
