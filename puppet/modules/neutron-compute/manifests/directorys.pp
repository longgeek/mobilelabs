class neutron-compute::directorys {
    file { ['/etc/neutron', '/var/log/neutron', '/etc/neutron/plugins', '/etc/neutron/plugins/ml2', '/etc/neutron/rootwrap.d', '/var/run/neutron']:
        ensure => directory,
    }
}
