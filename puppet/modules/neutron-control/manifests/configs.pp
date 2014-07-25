class neutron-control::configs {

    file { '/etc/logrotate.d/neutron':
        source => 'puppet:///files/neutron/logrotate.d/neutron',
    }

    file { '/etc/neutron/api-paste.ini':
        source  => 'puppet:///files/neutron/etc/api-paste.ini',
        require => File['/etc/logrotate.d/neutron'],
    }

    file { '/etc/neutron/policy.json':
        source  => 'puppet:///files/neutron/etc/policy.json',
        require => File['/etc/neutron/api-paste.ini'],
    }

    file { '/etc/neutron/rootwrap.conf':
        source  => 'puppet:///files/neutron/etc/rootwrap.conf',
        require => File['/etc/neutron/policy.json'],
    }

    file { '/etc/neutron/neutron.conf':
        content => template('neutron/neutron.conf.erb'),
        require => File['/etc/neutron/rootwrap.conf'],
        notify  => Class['neutron-control::services'],
    }

    file { '/etc/neutron/plugins/ml2/ml2_conf.ini':
        content => template('neutron/ml2_conf.ini.erb'),
        require => File['/etc/neutron/neutron.conf'],
        notify  => Class['neutron-control::services'],
    }
}
