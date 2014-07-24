class rabbitmq {
    Class['rabbitmq::packages'] -> Class['rabbitmq::services'] -> Class['rabbitmq::password'] -> Class['rabbitmq::iptables']
    include rabbitmq::packages, rabbitmq::services, rabbitmq::password, rabbitmq::iptables
}
