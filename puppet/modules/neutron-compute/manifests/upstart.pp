class neutron-compute::upstart {
    file { '/etc/init.d/neutron-openvswitch-agent':
        source => 'puppet:///files/neutron/init.d/neutron-openvswitch-agent',
    }

    exec { 'chkconfig neutron-openvswitch-agent':
        command => 'chkconfig --add neutron-openvswitch-agent; \
                    chkconfig neutron-openvswitch-agent on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep neutron-openvswitch-agent',
        require => File['/etc/init.d/neutron-openvswitch-agent'],
    }
}
