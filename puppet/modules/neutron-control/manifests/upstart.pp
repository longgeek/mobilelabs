class neutron-control::upstart {
    file { '/etc/init.d/neutron-server':
        source => 'puppet:///files/neutron/init.d/neutron-server',
    }

    exec { 'chkconfig neutron-server':
        command => 'chkconfig --add neutron-server; \
                    chkconfig neutron-server on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep neutron-server',
        require => File['/etc/init.d/neutron-server'],
    }
}
