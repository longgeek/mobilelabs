class glance::upstart {
    file { '/etc/init.d/glance-api':
        source => 'puppet:///files/glance/init.d/glance-api',
        notify => File['/etc/init.d/glance-registry'],
    }

    file { '/etc/init.d/glance-registry':
        source => 'puppet:///files/glance/init.d/glance-registry',
        notify => Exec['chkconfig glance-api'],
    }

    exec { 'chkconfig glance-api':
        command => 'chkconfig --add glance-api; \
                    chkconfig glance-api on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep glance-api',
        notify  => Exec['chkconfig glance-registry'],
    }

    exec { 'chkconfig glance-registry':
        command => 'chkconfig --add glance-registry; \
                    chkconfig glance-registry on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep glance-registry',
    }
}
