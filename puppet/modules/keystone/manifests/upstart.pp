class keystone::upstart {
    file { '/etc/init.d/keystone':
        source => 'puppet:///files/keystone/init.d/keystone',
        mode   => 0755,
        notify => Exec['chkconfig keystone'],
    }

    exec { 'chkconfig keystone':
        command => 'chkconfig --add keystone; \
                    chkconfig keystone on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep keystone',
    }
}
