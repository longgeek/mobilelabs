class neutron-compute {
    Class['neutron-compute::sources'] -> Class['neutron-compute::packages'] -> Class['neutron-compute::directorys'] -> Class['neutron-compute::upstart'] -> Class['neutron-compute::configs'] -> Class['neutron-compute::services'] -> Class['neutron-compute::check']
    include neutron-compute::sources, neutron-compute::packages, neutron-compute::directorys, neutron-compute::upstart, neutron-compute::configs, neutron-compute::services, neutron-compute::check
}
