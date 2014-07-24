class nova-compute::packages {
    package { ['libvirt-python', 'qemu-kvm', 'libvirt', 'dnsmasq-utils', 'polkit', 'tunctl', 'dbus', 'dnsmasq']:
        ensure => installed,
        notify => Exec['install python-novaclient'],
    }

    exec { 'install python-novaclient':
        command => 'pip install python-novaclient',
        path    => $command_path,
        unless  => 'which nova',
        notify  => Service['libvirtd'],
    }

    service { 'libvirtd':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
