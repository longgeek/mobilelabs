class neutron-network::packages {
    package { ['openvswitch', 'haproxy', 'openswan', 'dnsmasq-utils', 'dnsmasq', 'iproute-2.6.32-130.el6ost.netns.2']:
        ensure => installed,
    }

    service { 'openvswitch':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Package['openvswitch', 'haproxy', 'openswan', 'dnsmasq-utils', 'dnsmasq'],
    }
}
