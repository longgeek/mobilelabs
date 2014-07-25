class neutron-control::tables {
    exec { 'sync neutron db':
        command     => 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head',
        path        => $command_path,
        refreshonly => 'true',
        notify      => Class['neutron-control::services'],
    }

    exec { 'check neutron tables':
        command => 'neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head',
        path    => $command_path,
        require => Exec['sync neutron db'],
        notify  => Class['neutron-control::services'],
        onlyif  => "mysql -u$neutron_db_user -p$neutron_db_password -h $mysql_host -e 'show databases' | grep $neutron_db_name && \
                  [ \"`mysql -u$neutron_db_user -p$neutron_db_password -h $mysql_host $neutron_db_name -e 'show tables;' | wc -l`\" -eq \"0\" ]",
    }
}
