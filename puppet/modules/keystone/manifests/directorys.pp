class keystone::directorys {
    file { ['/etc/keystone', '/var/log/keystone', '/var/run/keystone']:
        ensure => directory,
    }
}
