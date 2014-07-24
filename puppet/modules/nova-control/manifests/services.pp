class nova-control::services {
    service { ['nova-api', 'nova-cert', 'nova-scheduler', 'nova-conductor', 'nova-consoleauth', 'nova-novncproxy']:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }

#    if $enable_spice == 'True' {
#        service { 'nova-spicehtml5proxy':
#            ensure     => running,
#            enable     => true,
#            hasstatus  => true,
#            hasrestart => true,
#        }
#
#        service { 'nova-novncproxy':
#            ensure => stopped,
#            enable => false,
#        }
#
#    } else {
#        service { 'nova-novncproxy':
#            ensure     => running,
#            enable     => true,
#            hasstatus  => true,
#            hasrestart => true,
#        }
#
#        service { 'nova-spicehtml5proxy':
#            ensure => stopped,
#            enable => false,
#        }
#    }
}
