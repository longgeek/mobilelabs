class nova-compute::services {
    service { 'nova-compute':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
