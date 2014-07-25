class keystone::configs {
    file { '/etc/logrotate.d/keystone':
        source => 'puppet:///files/keystone/logrotate.d/keystone',
    }

    file { '/etc/keystone/keystone-endpoint.sh':
        content => template('keystone/keystone-endpoint.sh.erb'),
        require => File['/etc/logrotate.d/keystone'],
    }

    file { '/etc/keystone/keystone-paste.ini':
        source  => 'puppet:///files/keystone/etc/keystone-paste.ini',
        require => File['/etc/keystone/keystone-endpoint.sh'],
    }

    file { '/etc/keystone/policy.json':
        source  => 'puppet:///files/keystone/etc/policy.json',
        require => File['/etc/keystone/keystone-paste.ini'],
    }

    file { '/etc/keystone/logging.conf':
        source  => 'puppet:///files/keystone/etc/logging.conf',
        require => File['/etc/keystone/policy.json'],
    }

    file { '/etc/keystone/keystone.conf':
        content => template('keystone/keystone.conf.erb'),
        notify  => Class['keystone::tables', 'keystone::services'],
        require => File['/etc/keystone/logging.conf'],
    }
}
