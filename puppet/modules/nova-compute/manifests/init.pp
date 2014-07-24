class nova-compute {
    Class['nova-compute::sources'] -> Class['nova-compute::packages'] -> Class['nova-compute::directorys'] -> Class['nova-compute::upstart'] -> Class['nova-compute::configs'] -> Class['nova-compute::tables'] -> Class['nova-compute::services'] -> Class['nova-compute::iptables'] -> Class['nova-compute::nbd']
    include nova-compute::sources, nova-compute::packages, nova-compute::directorys, nova-compute::upstart, nova-compute::configs, nova-compute::tables, nova-compute::services, nova-compute::iptables, nova-compute::nbd
}
