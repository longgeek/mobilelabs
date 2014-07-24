class horizon::packages {
    package { ['httpd', 'memcached', 'python-memcached', 'mod_wsgi']:
        ensure => installed,
    }
}
