class nova-compute::upstart {
    file { '/etc/init.d/nova-compute':
        source => 'puppet:///files/nova/init.d/nova-compute',
        notify => Exec['chkconfig nova-compute'],
    }

    exec { 'chkconfig nova-compute':
        command => 'chkconfig --add nova-compute; \
                    chkconfig nova-compute on',
        path    => $command_path,
        unless  => 'chkconfig --list | grep nova-compute',
    }
}
