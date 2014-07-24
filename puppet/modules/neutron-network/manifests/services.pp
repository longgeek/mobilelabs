class neutron-network::services {
    service {['neutron-openvswitch-agent', 'neutron-dhcp-agent', 'neutron-l3-agent', 'neutron-metadata-agent']:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }

##    service { 'neutron-metering-agent':
##        ensure => stopped,
##        enable => false,
##    }
}
