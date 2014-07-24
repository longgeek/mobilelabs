class nova-compute::configs {
    file { '/etc/logrotate.d/nova':
        source => 'puppet:///files/nova/logrotate.d/nova',
        notify => File['/etc/sudoers.d/nova'],
    }

    file { '/etc/sudoers.d/nova':
        source => 'puppet:///files/nova/sudoers.d/nova',
        notify => File['/etc/nova/policy.json'],
    }

    file { '/etc/nova/policy.json':
        source => 'puppet:///files/nova/etc/policy.json',
        notify => File['/etc/nova/rootwrap.conf'],
    }

    file { '/etc/nova/rootwrap.conf':
        source => 'puppet:///files/nova/etc/rootwrap.conf',
        notify => File['/etc/nova/rootwrap.d/api-metadata.filters'],
    }

    file { '/etc/nova/rootwrap.d/api-metadata.filters':
        source => 'puppet:///files/nova/etc/rootwrap.d/api-metadata.filters',
        notify => File['/etc/nova/rootwrap.d/baremetal-compute-ipmi.filters'],
    }

    file { '/etc/nova/rootwrap.d/baremetal-compute-ipmi.filters':
        source => 'puppet:///files/nova/etc/rootwrap.d/baremetal-compute-ipmi.filters',
        notify => File['/etc/nova/rootwrap.d/baremetal-deploy-helper.filters'],
    }

    file { '/etc/nova/rootwrap.d/baremetal-deploy-helper.filters':
        source => 'puppet:///files/nova/etc/rootwrap.d/baremetal-deploy-helper.filters',
        notify => File['/etc/nova/rootwrap.d/compute.filters'],
    }

    file { '/etc/nova/rootwrap.d/compute.filters':
        source => 'puppet:///files/nova/etc/rootwrap.d/compute.filters',
        notify => File['/etc/nova/rootwrap.d/docker.filters'],
    }

    file { '/etc/nova/rootwrap.d/docker.filters':
        source => 'puppet:///files/nova/etc/rootwrap.d/docker.filters',
        notify => File['/etc/nova/rootwrap.d/network.filters'],
    }

    file { '/etc/nova/rootwrap.d/network.filters':
        source => 'puppet:///files/nova/etc/rootwrap.d/network.filters',
        notify => File['/etc/nova/api-paste.ini'],
    }

    file { '/etc/nova/api-paste.ini':
        content => template('nova/api-paste.ini.erb'),
        notify  => [File['/etc/nova/nova.conf'], Class['nova-compute::tables', 'nova-compute::services']],
    }

    file { '/etc/nova/nova.conf':
        content => template('nova/nova-compute.conf.erb'),
        notify  => Class['nova-compute::tables', 'nova-compute::services'],
    }
}
