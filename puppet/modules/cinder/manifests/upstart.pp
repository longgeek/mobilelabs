class cinder::upstart {
    file {
        '/etc/init.d/cinder-api':
            source => 'puppet:///files/cinder/init.d/cinder-api';

        '/etc/init.d/cinder-scheduler':
            source => 'puppet:///files/cinder/init.d/cinder-scheduler';

        '/etc/init.d/cinder-volume':
            source => 'puppet:///files/cinder/init.d/cinder-volume',
    }

    exec { 'chkconfig cinder-api':
        command => 'chkconfig --add cinder-api; \
                    chkconfig cinder-api on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep cinder-api',
        require => File['/etc/init.d/cinder-api'],
    }

    exec { 'chkconfig cinder-scheduler':
        command => 'chkconfig --add cinder-scheduler; \
                    chkconfig cinder-scheduler on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep cinder-scheduler',
        require => File['/etc/init.d/cinder-scheduler'],
    }

    exec { 'chkconfig cinder-volume':
        command => 'chkconfig --add cinder-volume; \
                    chkconfig cinder-volume on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep cinder-volume',
        require => File['/etc/init.d/cinder-volume'],
    }
}
