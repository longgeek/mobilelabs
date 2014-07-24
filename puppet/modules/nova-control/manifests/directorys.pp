class nova-control::directorys {
    file { ['/etc/nova', '/var/log/nova', '/etc/nova/rootwrap.d', '/var/lib/nova', '/var/lib/nova/instances', '/var/run/nova']:
        ensure => directory,
    }
}
