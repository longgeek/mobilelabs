class nova-control::packages {
    package { ['novnc']:
        ensure => installed,
    }
}
