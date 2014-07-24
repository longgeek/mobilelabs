class mysql {
    Class['mysql::packages'] -> Class['mysql::services'] -> Class['mysql::password'] -> Class['mysql::databases'] -> Class['mysql::iptables']
    include mysql::packages, mysql::services, mysql::password, mysql::databases, mysql::iptables
}
