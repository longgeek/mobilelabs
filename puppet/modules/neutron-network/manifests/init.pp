class neutron-network {
    Class['neutron-network::sources'] -> Class['neutron-network::packages'] -> Class['neutron-network::directorys'] -> Class['neutron-network::upstart'] -> Class['neutron-network::configs'] -> Class['neutron-network::services'] -> Class['neutron-network::check'] -> Class['neutron-network::bridges'] -> Class['neutron-network::iptables']
    include neutron-network::sources, neutron-network::packages, neutron-network::directorys, neutron-network::upstart, neutron-network::configs, neutron-network::services, neutron-network::check, neutron-network::bridges, neutron-network::iptables
}
