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

    file { '/etc/neutron/.neutron.conf.puppet':
        content => template('neutron/neutron.conf.erb'),
        require => File['/etc/neutron/rootwrap.conf'],
    }

    file { '/etc/neutron/.get-service-tenant.sh':
        content => template('neutron/get-service-tenant.sh.erb'),
        require => File['/etc/neutron/.neutron.conf.puppet'],
        notify  => Exec['update neutron.conf'],
    }

    exec { 'update neutron.conf':
        command     => 'sh /etc/neutron/.get-service-tenant.sh',
        path        => $command_path,
        refreshonly => true,
        require     => File['/etc/neutron/.get-service-tenant.sh'],
        notify      => Class['neutron-control::services'],
    }

    file { '/etc/neutron/plugins/ml2/ml2_conf.ini.sh':
        content => template('neutron/ml2_conf.ini.erb'),
        require => Exec['update neutron.conf'],
        notify  => Exec['sh ml2_conf.ini.sh'],
    }

    exec { 'sh ml2_conf.ini.sh':
        command     => 'sh /etc/neutron/plugins/ml2/ml2_conf.ini.sh',
        path        => $command_path,
        refreshonly => true,
        require     => File['/etc/neutron/plugins/ml2/ml2_conf.ini.sh'],
        notify      => Class['neutron-control::services'],
    }
}
