class neutron-control {
    Class['neutron-control::sources'] -> Class['neutron-control::directorys'] -> Class['neutron-control::upstart'] -> Class['neutron-control::configs'] -> Class['neutron-control::tables'] -> Class['neutron-control::services'] -> Class['neutron-control::iptables']
    include neutron-control::sources, neutron-control::directorys, neutron-control::upstart, neutron-control::configs, neutron-control::tables, neutron-control::services, neutron-control::iptables
}
