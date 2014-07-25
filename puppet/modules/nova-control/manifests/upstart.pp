class nova-control::upstart {
    file { '/etc/init.d/nova-api':
        source  => 'puppet:///files/nova/init.d/nova-api',
    }

    file { '/etc/init.d/nova-cert':
        source  => 'puppet:///files/nova/init.d/nova-cert',
        require => File['/etc/init.d/nova-api'],
    }

    file { '/etc/init.d/nova-scheduler':
        source  => 'puppet:///files/nova/init.d/nova-scheduler',
        require => File['/etc/init.d/nova-cert'],
    }

    file { '/etc/init.d/nova-conductor':
        source  => 'puppet:///files/nova/init.d/nova-conductor',
        require => File['/etc/init.d/nova-scheduler'],
    }

    file { '/etc/init.d/nova-consoleauth':
        source  => 'puppet:///files/nova/init.d/nova-consoleauth',
        require => File['/etc/init.d/nova-conductor'],
    }

    file { '/etc/init.d/nova-novncproxy':
        source  => 'puppet:///files/nova/init.d/nova-novncproxy',
        require => File['/etc/init.d/nova-consoleauth'],
    }

    exec { 'chkconfig nova-api':
        command => 'chkconfig --add nova-api; \
                    chkconfig nova-api on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-api',
        require => File['/etc/init.d/nova-novncproxy'],
    }

    exec { 'chkconfig nova-cert':
        command => 'chkconfig --add nova-cert; \
                    chkconfig nova-cert on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-cert',
        require => Exec['chkconfig nova-api'],
    }

    exec { 'chkconfig nova-scheduler':
        command => 'chkconfig --add nova-scheduler; \
                    chkconfig nova-scheduler on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-scheduler',
        require => Exec['chkconfig nova-cert'],
    }

    exec { 'chkconfig nova-conductor':
        command => 'chkconfig --add nova-conductor; \
                    chkconfig nova-conductor on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-conductor',
        require => Exec['chkconfig nova-scheduler'],
    }

    exec { 'chkconfig nova-consoleauth':
        command => 'chkconfig --add nova-consoleauth; \
                    chkconfig nova-consoleauth on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-consoleauth',
        require => Exec['chkconfig nova-conductor'],
    }

    exec { 'chkconfig nova-novncproxy':
        command => 'chkconfig --add nova-novncproxy; \
                    chkconfig nova-novncproxy on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-novncproxy',
        require => Exec['chkconfig nova-consoleauth'],
    }
}
