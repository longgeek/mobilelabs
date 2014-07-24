class keystone::services {
    service { 'keystone':
        ensure     => 'running',
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }

    exec { 'check endpoint tables':
        command => 'sh /etc/keystone/keystone-endpoint.sh',
        path    => $command_path,
        timeout => '0',
        onlyif  => "[ \"`mysql -u$keystone_db_user -p$keystone_db_password -h $mysql_host $keystone_db_name -e 'select * from keystone.endpoint;' | wc -l`\" -eq \"0\" ]",
    }
}
