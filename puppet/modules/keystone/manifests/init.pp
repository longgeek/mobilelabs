class keystone {
    Class['keystone::sources'] -> Class['keystone::directorys'] -> Class['keystone::configs'] -> Class['keystone::tables'] -> Class['keystone::upstart'] -> Class['keystone::services'] -> Class['keystone::iptables']
    include keystone::sources, keystone::directorys, keystone::configs, keystone::tables, keystone::upstart, keystone::services, keystone::iptables
}
