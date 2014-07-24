class mysql::password {
    exec { 'set mysql password':
        command => "sed -i \"s/\[mysqld\]/\[mysqld\]\\nskip-grant-tables/g\" /etc/my.cnf; \
                   /etc/init.d/mysqld restart; \
                   mysql -uroot -e \"update mysql.user set password=PASSWORD('$mysql_root_pass') where User='root';\"; \
                   sed -i '/skip-grant-tables/d' /etc/my.cnf; \
                   /etc/init.d/mysqld restart", 
        path    => $command_path,
        unless  => "mysql -uroot -p$mysql_root_pass",
    }
}
