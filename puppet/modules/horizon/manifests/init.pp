class horizon {
    Class['horizon::packages'] -> Class['horizon::sources'] -> Class['horizon::configs'] -> Class['horizon::services'] -> Class['horizon::iptables']
    include horizon::packages, horizon::sources, horizon::configs, horizon::services, horizon::iptables
}
