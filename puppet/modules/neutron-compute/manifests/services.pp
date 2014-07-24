class neutron-compute::services {
    service {['neutron-openvswitch-agent', 'openvswitch']:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
