class keystone::configs {
    file { '/etc/logrotate.d/keystone':
        source => 'puppet:///files/keystone/logrotate.d/keystone',
        notify => File['/etc/keystone/keystone-endpoint.sh'],
    }

    file { '/etc/keystone/keystone-endpoint.sh':
        content => template('keystone/keystone-endpoint.sh.erb'),
        notify  => File['/etc/keystone/keystone-paste.ini'],
    }

    file { '/etc/keystone/keystone-paste.ini':
        source => 'puppet:///files/keystone/etc/keystone-paste.ini',
        notify => File['/etc/keystone/policy.json'],
    }

    file { '/etc/keystone/policy.json':
        source => 'puppet:///files/keystone/etc/policy.json',
        notify => File['/etc/keystone/logging.conf'],
    }

    file { '/etc/keystone/logging.conf':
        source => 'puppet:///files/keystone/etc/logging.conf',
        notify => File['/etc/keystone/keystone.conf'],
    }

    file { '/etc/keystone/keystone.conf':
        content => template('keystone/keystone.conf.erb'),
        notify  => Class['keystone::tables', 'keystone::services'],
    }
}
