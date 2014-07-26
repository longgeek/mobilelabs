class neutron-compute::bridges {

    exec { 'create br-int':
        command => "ovs-vsctl add-br br-$br_int; \
                    ovs-vsctl add-port br-$br_int $br_int",
        path    => $command_path,
        unless  => "ovs-vsctl list-br | grep br-$br_int",
    }

    exec { 'set br-int interface':
        command => "cp -f ifcfg-$br_int ifcfg-br-$br_int; \
                    sed -i 's/DEVICE.*$/DEVICE=br-$br_int/g' ifcfg-br-$br_int; \
                    sed -i '2i DEVICETYPE=ovs' ifcfg-br-$br_int; \
                    sed -i '/HWADDR/d' ifcfg-br-$br_int; \
                    sed -i 's/TYPE.*$/TYPE=OVSBridge/g' ifcfg-br-$br_int",
        path    => $command_path,
        cwd     => '/etc/sysconfig/network-scripts/',
        unless  => "ls /etc/sysconfig/network-scripts/ifcfg-br-$br_int",
        require => Exec['create br-int'],
        notify  => Service['network'],
    }

    file { "/etc/sysconfig/network-scripts/ifcfg-$br_int":
        content => template('neutron/ifcfg-br-int.erb'),
        notify  => Service['network'],
        require => Exec['set br-int interface'],
    }

    service { 'network':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => File["/etc/sysconfig/network-scripts/ifcfg-$br_int"],
    }
}
