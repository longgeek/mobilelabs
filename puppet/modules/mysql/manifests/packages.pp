class mysql::packages {
    package { ['mysql-server', 'MySQL-python']:
        ensure => installed,
    }
}
