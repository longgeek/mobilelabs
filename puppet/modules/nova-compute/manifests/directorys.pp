class nova-compute::directorys {
    file { ['/etc/nova', '/var/log/nova', '/etc/nova/rootwrap.d', '/var/lib/nova', '/var/run/nova', '/var/lib/nova/instances']:
        ensure => directory,
    }
}
