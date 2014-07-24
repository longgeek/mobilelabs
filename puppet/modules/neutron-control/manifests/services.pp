class neutron-control::services {
    service { 'neutron-server':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
