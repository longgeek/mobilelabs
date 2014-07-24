class glance::configs {
    file { '/etc/logrotate.d/glance':
        source => 'puppet:///files/glance/logrotate.d/glance',
        notify => File['/etc/glance/policy.json'],
    }
 
    file { '/etc/glance/policy.json':
        source => 'puppet:///files/glance/etc/policy.json',
        notify => File['/etc/glance/schema-image.json'],
    }
 
    file { '/etc/glance/schema-image.json':
        source => 'puppet:///files/glance/etc/schema-image.json',
        notify => File['/etc/glance/glance-api-paste.ini'],
    }
 
    file { '/etc/glance/glance-api-paste.ini':
        source => 'puppet:///files/glance/etc/glance-api-paste.ini',
        notify => File['/etc/glance/glance-registry-paste.ini'],
    }
 
    file { '/etc/glance/glance-registry-paste.ini':
        source => 'puppet:///files/glance/etc/glance-registry-paste.ini',
        notify => File['/etc/glance/glance-cache.conf'],
    }
 
    file { '/etc/glance/glance-cache.conf':
        content => template('glance/glance-cache.conf.erb'),
        notify => File['/etc/glance/glance-api.conf'],
    }

    file { '/etc/glance/glance-api.conf':
        content => template('glance/glance-api.conf.erb'),
        require => File['/etc/glance/glance-cache.conf'],
        notify  => Class['glance::tables', 'glance::services'],
    }

    file {'/etc/glance/glance-registry.conf':
        content => template('glance/glance-registry.conf.erb'),
        require => File['/etc/glance/glance-api.conf'],
        notify  => Class['glance::tables', 'glance::services'],
    }
}
