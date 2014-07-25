class nova-compute::nbd {
    package { ['kernel-devel', 'kernel-headers', 'glib2-devel']:
        ensure => 'installed',
    }

    file { '/usr/local/src/linux-2.6.32-431.el6.tar.bz2':
        source  => 'puppet:///files/sources/linux-2.6.32-431.el6.tar.bz2',
        require => Package['kernel-devel', 'kernel-headers', 'glib2-devel'],
    }

    file { '/usr/local/src/make-nbd.sh':
        source  => 'puppet:///files/nova/etc/make-nbd.sh',
        mode    => 0755,
        require => File['/usr/local/src/linux-2.6.32-431.el6.tar.bz2'],
    }

    exec { 'make nbd module':
        command => 'sh /usr/local/src/make-nbd.sh',
        path    => $command_path,
        timeout => '0',
        unless  => 'lsmod | grep nbd',
        require => File['/usr/local/src/make-nbd.sh'],
    }

    exec { 'autoload nbd':
        command => 'echo nbd >> /etc/modules && modprobe nbd',
        path    => $command_path,
        require => Exec['make nbd module'],
        unless  => 'grep nbd /etc/modules',
    }

    file { '/usr/local/src/qemu-0.15.1.tar.gz':
        source  => 'puppet:///files/sources/qemu-0.15.1.tar.gz',
        require => Exec['autoload nbd'],
    }
 
    exec { 'untar qemu':
        command => 'tar zxf /usr/local/src/qemu-0.15.1.tar.gz -C /usr/local/src/',
        path    => $command_path,
        unless  => 'ls /usr/local/src/qemu-0.15.1',
        require => File['/usr/local/src/qemu-0.15.1.tar.gz'],
    }

    exec { 'make qemu':
        command => 'sh configure --prefix=/usr/local/src/qemu-0.15.1; \
                    make && \
                    make install && \
                    ln -s /usr/local/src/qemu-0.15.1/bin/qemu-nbd /usr/bin/',
        cwd     => '/usr/local/src/qemu-0.15.1',
        path    => $command_path,
        timeout => '0',
        unless  => 'ls /usr/bin/qemu-nbd',
        require => Exec['untar qemu'],
        
    }
}
