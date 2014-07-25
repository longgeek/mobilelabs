class glance {
    Class['glance'] -> Class['glance::sources'] -> Class['glance::directorys'] -> Class['glance::configs'] -> Class['glance::tables'] -> Class['glance::upstart'] -> Class['glance::services'] -> Class['glance::iptables']
    include glance, glance::sources, glance::directorys, glance::configs, glance::tables, glance::upstart, glance::services, glance::iptables
}
