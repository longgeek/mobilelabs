class nova-control::upstart {
    file { '/etc/init.d/nova-api':
        source => 'puppet:///files/nova/init.d/nova-api',
        notify => File['/etc/init.d/nova-cert'],
    }

    file { '/etc/init.d/nova-cert':
        source => 'puppet:///files/nova/init.d/nova-cert',
        notify => File['/etc/init.d/nova-scheduler'],
    }

    file { '/etc/init.d/nova-scheduler':
        source => 'puppet:///files/nova/init.d/nova-scheduler',
        notify => File['/etc/init.d/nova-conductor'],
    }

    file { '/etc/init.d/nova-conductor':
        source => 'puppet:///files/nova/init.d/nova-conductor',
        notify => File['/etc/init.d/nova-consoleauth'],
    }

    file { '/etc/init.d/nova-consoleauth':
        source => 'puppet:///files/nova/init.d/nova-consoleauth',
        notify => File['/etc/init.d/nova-novncproxy'],
    }

    file { '/etc/init.d/nova-novncproxy':
        source => 'puppet:///files/nova/init.d/nova-novncproxy',
        notify => Exec['chkconfig nova-api'],
    }

    exec { 'chkconfig nova-api':
        command => 'chkconfig --add nova-api; \
                    chkconfig nova-api on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-api',
        notify  => Exec['chkconfig nova-cert'],
    }

    exec { 'chkconfig nova-cert':
        command => 'chkconfig --add nova-cert; \
                    chkconfig nova-cert on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-cert',
        notify  => Exec['chkconfig nova-scheduler'],
    }

    exec { 'chkconfig nova-scheduler':
        command => 'chkconfig --add nova-scheduler; \
                    chkconfig nova-scheduler on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-scheduler',
        notify  => Exec['chkconfig nova-conductor'],
    }

    exec { 'chkconfig nova-conductor':
        command => 'chkconfig --add nova-conductor; \
                    chkconfig nova-conductor on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-conductor',
        notify  => Exec['chkconfig nova-consoleauth'],
    }

    exec { 'chkconfig nova-consoleauth':
        command => 'chkconfig --add nova-consoleauth; \
                    chkconfig nova-consoleauth on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-consoleauth',
        notify  => Exec['chkconfig nova-novncproxy'],
    }

    exec { 'chkconfig nova-novncproxy':
        command => 'chkconfig --add nova-novncproxy; \
                    chkconfig nova-novncproxy on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-novncproxy',
    }
}
