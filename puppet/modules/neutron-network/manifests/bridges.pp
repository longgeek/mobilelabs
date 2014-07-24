class neutron-network::bridges {
    exec { 'create br-int':
        command => 'ovs-vsctl add-br br-int',
        path    => $command_path,
        unless  => 'ovs-vsctl list-br | grep br-int',
        notify  => Exec['create br-ex'],
    }   

    exec { 'create br-ex':
        command => "ovs-vsctl add-br br-ex; \
                    ovs-vsctl add-port br-ex $br_ex",
        path    => $command_path,
        unless  => 'ovs-vsctl list-br | grep br-ex',
        notify  => Exec['set interface'],
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
        notify  => [File["/etc/sysconfig/network-scripts/ifcfg-$br_ex"], Service['network']],
    }

    file { "/etc/sysconfig/network-scripts/ifcfg-$br_ex":
        content => template('neutron/ifcfg-ethx.erb'),
        notify  => Service['network'],
    }

    service { 'network':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => File["/etc/sysconfig/network-scripts/ifcfg-$br_ex"],
    }
}
