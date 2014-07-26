class mysql::databases {
    exec { 'create keystone db':
        command => "mysql -uroot -p$mysql_root_pass -e \"create database $keystone_db_name default character set utf8;\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $keystone_db_name.* to '$keystone_db_user'@'%' identified by '$keystone_db_password';\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $keystone_db_name.* to '$keystone_db_user'@'$mysql_host' identified by '$keystone_db_password';\"",
        path    => $command_path,
        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep $keystone_db_name",
    }

    exec { 'create glance db':
        command => "mysql -uroot -p$mysql_root_pass -e \"create database $glance_db_name default character set utf8;\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $glance_db_name.* to '$glance_db_user'@'%' identified by '$glance_db_password';\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $glance_db_name.* to '$glance_db_user'@'$mysql_host' identified by '$glance_db_password';\"",
        path    => $command_path,
        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep $glance_db_name",
        require => Exec['create keystone db'],
##        notify  => Exec['create cinder db'],
    }

##    exec { 'create cinder db':
##        command => "mysql -uroot -p$mysql_root_pass -e \"create database $cinder_db_name default character set utf8;\" && \
##                    mysql -uroot -p$mysql_root_pass -e \"grant all on $cinder_db_name.* to '$cinder_db_user'@'%' identified by '$cinder_db_password';\" && \
##                    mysql -uroot -p$mysql_root_pass -e \"grant all on $cinder_db_name.* to '$cinder_db_user'@'$mysql_host' identified by '$cinder_db_password';\"",
##        path    => $command_path,
##        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep $cinder_db_name",
##        notify  => Exec['create nova db'],
##    }

    exec { 'create nova db':
        command => "mysql -uroot -p$mysql_root_pass -e \"create database $nova_db_name default character set utf8;\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $nova_db_name.* to '$nova_db_user'@'%' identified by '$nova_db_password';\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $nova_db_name.* to '$nova_db_user'@'$mysql_host' identified by '$nova_db_password';\"",
        path    => $command_path,
        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep $nova_db_name",
        require => Exec['create glance db'],
    }

    exec { 'create neutron db':
        command => "mysql -uroot -p$mysql_root_pass -e \"create database $neutron_db_name;\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $neutron_db_name.* to '$neutron_db_user'@'%' identified by '$neutron_db_password';\" && \
                    mysql -uroot -p$mysql_root_pass -e \"grant all on $neutron_db_name.* to '$neutron_db_user'@'$mysql_host' identified by '$neutron_db_password';\"",
        path    => $command_path,
        require => Exec['create nova db'],
        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep $neutron_db_name",
    }

##    exec { 'create ceilometer db':
##        command => "mysql -uroot -p$mysql_root_pass -e \"create database ceilometer default character set utf8;\" && \
##                    mysql -uroot -p$mysql_root_pass -e \"grant all on ceilometer.* to 'ceilometer'@'localhost' identified by 'ceilometer';\"",
##        path    => $command_path,
##        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep ceilometer",
##        notify  => Exec['create sahara db'],
##    }
##
##    exec { 'create sahara db':
##        command => "mysql -uroot -p$mysql_root_pass -e \"create database sahara default character set utf8;\" && \
##                    mysql -uroot -p$mysql_root_pass -e \"grant all on sahara.* to 'sahara'@'localhost' identified by 'sahara';\"",
##        path    => $command_path,
##        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep sahara",
##        notify  => Exec['create heat db'],
##    }
##
##    exec { 'create heat db':
##        command => "mysql -uroot -p$mysql_root_pass -e \"create database heat default character set utf8;\" && \
##                    mysql -uroot -p$mysql_root_pass -e \"grant all on heat.* to 'heat'@'localhost' identified by 'heat';\"",
##        path    => $command_path,
##        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep heat",
##        notify  => Class['mysql::services'],
##    }
##
##    exec { 'create trove db':
##        command => "mysql -uroot -p$mysql_root_pass -e \"create database trove default character set utf8;\" && \
##                    mysql -uroot -p$mysql_root_pass -e \"grant all on trove.* to 'trove'@'localhost' identified by 'trove';\"",
##        path    => $command_path,
##        unless  => "mysqlshow -uroot -p$mysql_root_pass | grep trove",
##    }
}
