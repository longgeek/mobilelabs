class keystone::tables {
    exec { 'sync keystone db':
        command     => 'keystone-manage db_sync',
        path        => $command_path,
        refreshonly => 'true',
        notify      => Class['keystone::services'],
    }

    exec { 'check keystone tables':
        command => 'keystone-manage db_sync',
        path    => $command_path,
        require => Exec['sync keystone db'],
        notify  => Class['keystone::services'],
        onlyif  => "mysql -u$keystone_db_user -p$keystone_db_password -h $mysql_host -e 'show databases' | grep $keystone_db_name && \
                  [ \"`mysql -u$keystone_db_user -p$keystone_db_password -h $mysql_host $keystone_db_name -e 'show tables;' | wc -l`\" -eq \"0\" ]",
    }
}
