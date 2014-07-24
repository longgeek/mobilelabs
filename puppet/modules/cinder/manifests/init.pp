class cinder {
    Class['cinder'] -> Class['cinder::sources'] -> Class['cinder::directorys'] -> Class['cinder::volumes'] -> Class['cinder::iscsi'] -> Class['cinder::configs'] -> Class['cinder::tables'] -> Class['cinder::upstart'] -> Class['cinder::services'] -> Class['cinder::iptables']
    include cinder, cinder::sources, cinder::directorys, cinder::volumes, cinder::iscsi, cinder::configs, cinder::tables, cinder::upstart, cinder::services, cinder::iptables

}
