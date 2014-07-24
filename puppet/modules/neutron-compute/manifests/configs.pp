class neutron-compute::configs {

    file { '/etc/logrotate.d/neutron':
        source => 'puppet:///files/neutron/logrotate.d/neutron',
        notify => File['/etc/sudoers.d/neutron'],
    }

    file { '/etc/sudoers.d/neutron':
        source => 'puppet:///files/neutron/sudoers.d/neutron',
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
        notify => File['/etc/neutron/rootwrap.d/debug.filters'],
    }

    file { '/etc/neutron/rootwrap.d/debug.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/debug.filters',
        notify => File['/etc/neutron/rootwrap.d/iptables-firewall.filters'],
    }

    file { '/etc/neutron/rootwrap.d/iptables-firewall.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/iptables-firewall.filters',
        notify => File['/etc/neutron/rootwrap.d/lbaas-haproxy.filters'],
    }

    file { '/etc/neutron/rootwrap.d/lbaas-haproxy.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/lbaas-haproxy.filters',
        notify => File['/etc/neutron/rootwrap.d/nec-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/nec-plugin.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/nec-plugin.filters',
        notify => File['/etc/neutron/rootwrap.d/ryu-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/ryu-plugin.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/ryu-plugin.filters',
        notify => File['/etc/neutron/rootwrap.d/dhcp.filters'],
    }

    file { '/etc/neutron/rootwrap.d/dhcp.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/dhcp.filters',
        notify => File['/etc/neutron/rootwrap.d/l3.filters'],
    }

    file { '/etc/neutron/rootwrap.d/l3.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/l3.filters',
        notify => File['/etc/neutron/rootwrap.d/linuxbridge-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/linuxbridge-plugin.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/linuxbridge-plugin.filters',
        notify => File['/etc/neutron/rootwrap.d/openvswitch-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/openvswitch-plugin.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/openvswitch-plugin.filters',
        notify => File['/etc/neutron/rootwrap.d/vpnaas.filters'],
    }

    file { '/etc/neutron/rootwrap.d/vpnaas.filters':
        source => 'puppet:///files/neutron/etc/rootwrap.d/vpnaas.filters',
        notify => File['/etc/neutron/neutron.conf'],
    }

    file { '/etc/neutron/neutron.conf':
        content => template('neutron/neutron.conf.erb'),
        require => File['/etc/neutron/rootwrap.d/vpnaas.filters'],
        notify  => Class['neutron-compute::services'],
    }

    file { '/etc/neutron/plugins/ml2/ml2_conf.ini':
        content => template('neutron/ml2_conf.ini.erb'),
        require => File['/etc/neutron/neutron.conf'],
        notify  => Class['neutron-compute::services'],
    }
}
