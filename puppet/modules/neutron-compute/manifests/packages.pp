class neutron-compute::packages {
    package { ['openvswitch', 'openswan']:
         ensure => 'installed',
    }
}
