class cinder::directorys {
    file { ['/etc/cinder', '/etc/cinder/rootwrap.d/', '/var/log/cinder', '/etc/cinder/volumes', '/var/run/cinder']:
        ensure => directory,
    }
}
