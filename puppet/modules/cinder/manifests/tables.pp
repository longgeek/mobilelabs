class cinder::tables {
    exec { 'sync cinder db':
        command     => 'cinder-manage db sync',
        path        => $command_path,
        notify      => Class['cinder::services'],
        refreshonly => 'true',
    }

    exec { 'check cinder tables':
        command => 'cinder-manage db sync',
        path    => $command_path,
        notify  => Class['cinder::services'],
        onlyif  => "mysql -u$cinder_db_user -p$cinder_db_password -h $mysql_host -e 'show databases' | grep $cinder_db_name && \
                  [ \"`mysql -u$cinder_db_user -p$cinder_db_password -h $mysql_host $cinder_db_name -e 'show tables;' | wc -l`\" -eq \"0\" ]",
    }
}
