class cinder::iscsi {
    package { ['libudev-devel', 'lvm2', 'scsi-target-utils', 'device-mapper']:
        ensure => installed,
        notify => File['/etc/tgt/targets.conf'],
    }

    file { '/etc/tgt/targets.conf':
        source => 'puppet:///files/cinder/etc/targets.conf',
        notify => Service['tgtd'],
    }

    service { ['tgtd']:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
