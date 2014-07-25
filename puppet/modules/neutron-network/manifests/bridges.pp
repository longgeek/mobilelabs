class neutron-network::bridges {
    exec { 'create br-int':
        command => 'ovs-vsctl add-br br-int',
        path    => $command_path,
        unless  => 'ovs-vsctl list-br | grep br-int',
    }   

    exec { 'create br-ex':
        command => "ovs-vsctl add-br br-ex; \
                    ovs-vsctl add-port br-ex $br_ex",
        path    => $command_path,
        unless  => 'ovs-vsctl list-br | grep br-ex',
        require => Exec['create br-int'],
    }

    exec { 'set interface':
        command => "cp -f ifcfg-$br_ex ifcfg-br-ex; \
                    sed -i 's/DEVICE.*$/DEVICE=br-ex/g' ifcfg-br-ex; \
                    sed -i '2i DEVICETYPE=ovs' ifcfg-br-ex; \
                    sed -i '/HWADDR/d' ifcfg-br-ex; \
                    sed -i 's/TYPE.*$/TYPE=OVSBridge/g' ifcfg-br-ex",
        path    => $command_path,
        cwd     => '/etc/sysconfig/network-scripts/',
        unless  => 'ls /etc/sysconfig/network-scripts/ifcfg-br-ex',
        require => Exec['create br-ex'],
        notify  => Service['network'],
    }

    file { "/etc/sysconfig/network-scripts/ifcfg-$br_ex":
        content => template('neutron/ifcfg-ethx.erb'),
        notify  => Service['network'],
        require => Exec['set interface'],
    }

    service { 'network':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => File["/etc/sysconfig/network-scripts/ifcfg-$br_ex"],
    }
}
