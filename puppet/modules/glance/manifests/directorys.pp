class glance::directorys {
    file { ['/etc/glance', '/var/log/glance', '/var/lib/glance', '/var/run/glance']:
        ensure => directory,
    }
}
