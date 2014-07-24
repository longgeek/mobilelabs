class nova-control::tables {
    exec { 'sync nova db':
        command     => 'nova-manage db sync',
        path        => $command_path,
        refreshonly => 'true',
        notify      => [Exec['check nova tables'], Class['nova-control::services']],
    }

    exec { 'check nova tables':
        command => 'nova-manage db sync',
        path    => $command_path,
        onlyif  => "mysql -u$nova_db_user -p$nova_db_password -h $mysql_host -e 'show databases' | grep $nova_db_name && \
                    [ \"`mysql -u$nova_db_user -p$nova_db_password -h $mysql_host $nova_db_name -e 'show tables;' | wc -l`\" -eq \"0\" ]",
        notify  => Class['nova-control::services'],
    }
}
