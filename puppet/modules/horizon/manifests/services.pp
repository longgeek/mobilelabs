class horizon::services {
    service { ['httpd', 'memcached']:
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
