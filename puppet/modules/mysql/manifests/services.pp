class mysql::services {
    service { 'mysqld':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
