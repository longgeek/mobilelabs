class horizon::configs {
    exec { 'chown apache':
        command => "chown -R apache:apache $sources_dir/sources/horizon",
        path    => $command_path,
        onlyif  => "[ $(find $sources_dir/sources/horizon/ -user root | wc -l) != '0' ]",
        notify  => File["$sources_dir/sources/horizon/.blackhole"],
    }

    file { "$sources_dir/sources/horizon/.blackhole":
        ensure => directory,
        notify => File["$sources_dir/sources/horizon/openstack_dashboard/settings.py"],
    }

    file { "$sources_dir/sources/horizon/openstack_dashboard/settings.py":
        source => 'puppet:///files/horizon/etc/settings.py',
        owner  => 'apache',
        group  => 'apache',
        notify => File["$sources_dir/sources/horizon/openstack_dashboard/local/local_settings.py"],
    }

    file { "$sources_dir/sources/horizon/openstack_dashboard/local/local_settings.py":
        content => template('horizon/local_settings.py.erb'),
        owner   => 'apache',
        group   => 'apache',
        notify  => File['/etc/httpd/conf.d/horizon.conf'],
    }

    file { '/etc/httpd/conf.d/horizon.conf':
        content => template('horizon/horizon.conf.erb'),
    }
}
