class nova-control::configs {
    file { '/etc/logrotate.d/nova':
        source  => 'puppet:///files/nova/logrotate.d/nova',
    }

    file { '/etc/sudoers.d/nova':
        source  => 'puppet:///files/nova/sudoers.d/nova',
        require =>  File['/etc/logrotate.d/nova'],
    }

    file { '/etc/nova/policy.json':
        source  => 'puppet:///files/nova/etc/policy.json',
        require => File['/etc/sudoers.d/nova'],
    }

    file { '/etc/nova/rootwrap.conf':
        source  => 'puppet:///files/nova/etc/rootwrap.conf',
        require => File['/etc/nova/policy.json'],
    }

    file { '/etc/nova/rootwrap.d/api-metadata.filters':
        source  => 'puppet:///files/nova/etc/rootwrap.d/api-metadata.filters',
        require => File['/etc/nova/rootwrap.conf'],
    }

    file { '/etc/nova/rootwrap.d/baremetal-compute-ipmi.filters':
        source  => 'puppet:///files/nova/etc/rootwrap.d/baremetal-compute-ipmi.filters',
        require => File['/etc/nova/rootwrap.d/api-metadata.filters'],
    }

    file { '/etc/nova/rootwrap.d/baremetal-deploy-helper.filters':
        source  => 'puppet:///files/nova/etc/rootwrap.d/baremetal-deploy-helper.filters',
        require => File['/etc/nova/rootwrap.d/baremetal-compute-ipmi.filters'],
    }

    file { '/etc/nova/rootwrap.d/compute.filters':
        source  => 'puppet:///files/nova/etc/rootwrap.d/compute.filters',
        require => File['/etc/nova/rootwrap.d/baremetal-deploy-helper.filters'],
    }

    file { '/etc/nova/rootwrap.d/docker.filters':
        source  => 'puppet:///files/nova/etc/rootwrap.d/docker.filters',
        require => File['/etc/nova/rootwrap.d/compute.filters'],
    }

    file { '/etc/nova/rootwrap.d/network.filters':
        source  => 'puppet:///files/nova/etc/rootwrap.d/network.filters',
        require => File['/etc/nova/rootwrap.d/docker.filters'],
    }

    file { '/etc/nova/api-paste.ini':
        content => template('nova/api-paste.ini.erb'),
        require => File['/etc/nova/rootwrap.d/network.filters'],
        notify  => Class['nova-control::tables', 'nova-control::services'],
    }

    file { '/etc/nova/nova.conf':
        content => template('nova/nova.conf.erb'),
        require => File['/etc/nova/api-paste.ini'],
        notify  => Class['nova-control::tables', 'nova-control::services'],
    }
}
