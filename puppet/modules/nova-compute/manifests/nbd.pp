class nova-compute::nbd {
    package { ['kernel-devel', 'kernel-headers']:
        ensure => 'installed',
        notify => File['/usr/local/src/linux-2.6.32-431.el6.tar.bz2'],
    }

    file { '/usr/local/src/linux-2.6.32-431.el6.tar.bz2':
        source => 'puppet:///files/sources/linux-2.6.32-431.el6.tar.bz2',
        notify => File['/usr/local/src/make-nbd.sh'],
    }

    file { '/usr/local/src/make-nbd.sh':
        source => 'puppet:///files/nova/etc/make-nbd.sh',
        mode   => 0755,
        notify => Exec['make nbd module'],
    }

    exec { 'make nbd module':
        command => 'sh /usr/local/src/make-nbd.sh',
        path    => $command_path,
        timeout => '0',
        unless  => 'lsmod | grep nbd',
        notify  => Exec['autoload nbd'],
    }

    exec { 'autoload nbd':
        command => 'echo nbd >> /etc/modules && modprobe nbd',
        path    => $command_path,
        unless  => 'grep nbd /etc/modules',
    }
}
