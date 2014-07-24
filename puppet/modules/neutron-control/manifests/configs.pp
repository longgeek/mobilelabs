class neutron-control::configs {

    file { '/etc/logrotate.d/neutron':
        source => 'puppet:///files/neutron/logrotate.d/neutron',
        notify => File['/etc/neutron/api-paste.ini'],
    }

    file { '/etc/neutron/api-paste.ini':
        source => 'puppet:///files/neutron/etc/api-paste.ini',
        notify => File['/etc/neutron/policy.json'],
    }

    file { '/etc/neutron/policy.json':
        source => 'puppet:///files/neutron/etc/policy.json',
        notify => File['/etc/neutron/rootwrap.conf'],
    }

    file { '/etc/neutron/rootwrap.conf':
        source => 'puppet:///files/neutron/etc/rootwrap.conf',
        notify => File['/etc/neutron/neutron.conf'],
    }

    file { '/etc/neutron/neutron.conf':
        content => template('neutron/neutron.conf.erb'),
        notify  => [File['/etc/neutron/plugins/ml2/ml2_conf.ini'], Class['neutron-control::services']],
    }

    file { '/etc/neutron/plugins/ml2/ml2_conf.ini':
        content => template('neutron/ml2_conf.ini.erb'),
        require => File['/etc/neutron/neutron.conf'],
        notify  => Class['neutron-control::services'],
    }
}
