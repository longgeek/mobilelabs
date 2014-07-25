class glance::tables {
    exec { 'sync glance db':
        command     => 'glance-manage db_sync',
        path        => $command_path,
        refreshonly => 'true',
        notify      => [Exec['check glance tables'], Class['glance::services']],
    }

    exec { 'check glance tables':
        command => 'glance-manage db_sync',
        path    => $command_path,
        notify  => Class['glance::services'],
        require => Exec['sync glance db'],
        onlyif  => "mysql -u$glance_db_user -p$glance_db_password -h $mysql_host -e 'show databases' | grep $glance_db_name && \
                  [ \"`mysql -u$glance_db_user -p$glance_db_password -h $mysql_host $glance_db_name -e 'show tables;' | wc -l`\" -eq \"0\" ]",
    }
}
