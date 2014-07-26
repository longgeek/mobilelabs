class bases {
    package { 'libffi-devel':
        ensure => installed,
    }

    exec { 'install pbr':
        command => 'pip install pbr',
        path    => $command_path,
        unless  => "python -c 'import pbr'",
        require => Package['libffi-devel'],
    }

    exec { 'install six':
        command => 'pip install six',
        path    => $command_path,
        unless  => "python -c 'import six'",
        require => Exec['install pbr'],
    }

    exec { 'install cffi':
        command => 'pip install cffi',
        path    => $command_path,
        unless  => "python -c 'import cffi'",
        require => Exec['install six'],
    }

    file { ["$sources_dir", "$sources_dir/sources", "$sources_dir/tar", '/root/.ssh']:
        ensure  => directory,
        require => Exec['install cffi'],
    }

    file { '/etc/profile.d/keystone-env.sh':
        content => template('keystone/keystone-env.sh.erb'),
        require => File["$sources_dir", "$sources_dir/sources", "$sources_dir/tar", '/root/.ssh'],
    }

    file { '/root/.ssh/authorized_keys':
        source  => 'puppet:///files/bases/id_rsa.pub',
        mode    => 0600,
        require => File['/etc/profile.d/keystone-env.sh'],
    }

    file { '/root/.ssh/id_rsa':
        source  => 'puppet:///files/bases/id_rsa',
        mode    => 0600,
        require => File['/root/.ssh/authorized_keys'],
    }

    file { '/root/.update-password.sh':
        content => template('bases/update-password.sh.erb'),
        mode    => 0600,
        require => File['/root/.ssh/id_rsa'],
        notify  => Exec['update root pass'],
    }

    exec { 'update root pass':
        command     => 'sh /root/.update-password.sh',
        path        => $command_path,
        require     => File['/root/.update-password.sh'],
        refreshonly => true,
    }
}
