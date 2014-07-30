class neutron-compute::configs {

    file { '/etc/logrotate.d/neutron':
        source  => 'puppet:///files/neutron/logrotate.d/neutron',
    }

    file { '/etc/sudoers.d/neutron':
        source  => 'puppet:///files/neutron/sudoers.d/neutron',
        require => File['/etc/logrotate.d/neutron'],
    }

    file { '/etc/neutron/api-paste.ini':
        source  => 'puppet:///files/neutron/etc/api-paste.ini',
        require => File['/etc/sudoers.d/neutron'],
    }

    file { '/etc/neutron/policy.json':
        source  => 'puppet:///files/neutron/etc/policy.json',
        require => File['/etc/neutron/api-paste.ini'],
    }

    file { '/etc/neutron/rootwrap.conf':
        source  => 'puppet:///files/neutron/etc/rootwrap.conf',
        require => File['/etc/neutron/policy.json'],
    }

    file { '/etc/neutron/rootwrap.d/debug.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/debug.filters',
        require => File['/etc/neutron/rootwrap.conf'],
    }

    file { '/etc/neutron/rootwrap.d/iptables-firewall.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/iptables-firewall.filters',
        require => File['/etc/neutron/rootwrap.d/debug.filters'],
    }

    file { '/etc/neutron/rootwrap.d/lbaas-haproxy.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/lbaas-haproxy.filters',
        require => File['/etc/neutron/rootwrap.d/iptables-firewall.filters'],
    }

    file { '/etc/neutron/rootwrap.d/nec-plugin.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/nec-plugin.filters',
        require => File['/etc/neutron/rootwrap.d/lbaas-haproxy.filters'],
    }

    file { '/etc/neutron/rootwrap.d/ryu-plugin.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/ryu-plugin.filters',
        require => File['/etc/neutron/rootwrap.d/nec-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/dhcp.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/dhcp.filters',
        require => File['/etc/neutron/rootwrap.d/ryu-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/l3.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/l3.filters',
        require => File['/etc/neutron/rootwrap.d/dhcp.filters'],
    }

    file { '/etc/neutron/rootwrap.d/linuxbridge-plugin.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/linuxbridge-plugin.filters',
        require => File['/etc/neutron/rootwrap.d/l3.filters'],
    }

    file { '/etc/neutron/rootwrap.d/openvswitch-plugin.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/openvswitch-plugin.filters',
        require => File['/etc/neutron/rootwrap.d/linuxbridge-plugin.filters'],
    }

    file { '/etc/neutron/rootwrap.d/vpnaas.filters':
        source  => 'puppet:///files/neutron/etc/rootwrap.d/vpnaas.filters',
        require => File['/etc/neutron/rootwrap.d/openvswitch-plugin.filters'],
    }

    file { '/etc/neutron/.neutron.conf.puppet':
        content => template('neutron/neutron.conf.erb'),
        require => File['/etc/neutron/rootwrap.d/vpnaas.filters'],
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
        notify      => Class['neutron-compute::services'],
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
        notify      => Class['neutron-compute::services'],
    }
}
