class neutron-network::directorys {
    file { '/var/lib/neutron':
        ensure => directory,
        mode   => 0755,
    }

    file { ['/etc/neutron', '/var/log/neutron', '/etc/neutron/plugins', '/etc/neutron/plugins/ml2', '/etc/neutron/rootwrap.d', '/var/run/neutron', '/etc/neutron/services/', '/etc/neutron/services/loadbalancer', '/etc/neutron/services/loadbalancer/haproxy']:
        ensure  => directory,
        require => File['/var/lib/neutron'],
    }
}
