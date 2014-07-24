class nova-control {
    Class['nova-control::sources'] -> Class['nova-control::packages'] -> Class['nova-control::directorys'] -> Class['nova-control::upstart'] -> Class['nova-control::configs'] -> Class['nova-control::tables'] -> Class['nova-control::services']
    include nova-control::sources, nova-control::packages, nova-control::directorys, nova-control::upstart, nova-control::configs, nova-control::tables, nova-control::services, nova-control::iptables
}
