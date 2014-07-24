class neutron-network::upstart {
    file { '/etc/init.d/neutron-l3-agent':
        source => 'puppet:///files/neutron/init.d/neutron-l3-agent',
        notify => File['/etc/init.d/neutron-metadata-agent'],
    }

    file { '/etc/init.d/neutron-metadata-agent':
        source => 'puppet:///files/neutron/init.d/neutron-metadata-agent',
        notify => File['/etc/init.d/neutron-openvswitch-agent'],
    }

    file { '/etc/init.d/neutron-openvswitch-agent':
        source => 'puppet:///files/neutron/init.d/neutron-openvswitch-agent',
        notify => File['/etc/init.d/neutron-dhcp-agent'],
    }

    file { '/etc/init.d/neutron-dhcp-agent':
        source => 'puppet:///files/neutron/init.d/neutron-dhcp-agent',
        notify => File['/etc/init.d/neutron-vpn-agent'],
    }

    file { '/etc/init.d/neutron-vpn-agent':
        source => 'puppet:///files/neutron/init.d/neutron-vpn-agent',
        notify => File['/etc/init.d/neutron-lbaas-agent'],
    }

    file { '/etc/init.d/neutron-lbaas-agent':
        source => 'puppet:///files/neutron/init.d/neutron-lbaas-agent',
        notify => Exec['chkconfig neutron-l3-agent'],

##        '/etc/init.d/neutron-metering-agent.conf':
##            source => 'puppet:///files/neutron/init.d/neutron-metering-agent.conf';
##
##        '/etc/init.d/neutron-server.conf':
##            source => 'puppet:///files/neutron/init.d/neutron-server.conf',
    }

    exec { 'chkconfig neutron-l3-agent':
        command => 'chkconfig --add neutron-l3-agent; \
                    chkconfig neutron-l3-agent on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep neutron-l3-agent',
        notify  => Exec['chkconfig neutron-dhcp-agent'],
    }

    exec { 'chkconfig neutron-dhcp-agent':
        command => 'chkconfig --add neutron-dhcp-agent; \
                    chkconfig neutron-dhcp-agent on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep neutron-dhcp-agent',
        notify  => Exec['chkconfig neutron-metadata-agent'],
    }

##    exec { 'chkconfig neutron-vpn-agent':
##        command => 'chkconfig --add neutron-vpn-agent; \
##                    chkconfig neutron-vpn-agent on',
##        path    => $command_path,
##        unless  => 'chkconfig --list | grep neutron-vpn-agent',
##    }
##
##    exec { 'chkconfig neutron-lbaas-agent':
##        command => 'chkconfig --add neutron-lbaas-agent; \
##                    chkconfig neutron-lbaas-agent on',
##        path    => $command_path,
##        unless  => 'chkconfig --list | grep neutron-lbaas-agent',
##    }

    exec { 'chkconfig neutron-metadata-agent':
        command => 'chkconfig --add neutron-metadata-agent; \
                    chkconfig neutron-metadata-agent on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep neutron-metadata-agent',
        notify  => Exec['chkconfig neutron-openvswitch-agent'],
    }

    exec { 'chkconfig neutron-openvswitch-agent':
        command => 'chkconfig --add neutron-openvswitch-agent; \
                    chkconfig neutron-openvswitch-agent on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep neutron-openvswitch-agent',
    }
}
