class nova-compute::packages {
    package { ['libvirt-python', 'qemu-kvm', 'libvirt', 'dnsmasq-utils', 'polkit', 'tunctl', 'dbus', 'dnsmasq', 'bridge-utils', 'libguestfs', 'python-libguestfs', 'libguestfs-tools-c']:
        ensure => installed,
    }

    exec { 'install python-novaclient':
        command => 'pip install python-novaclient',
        path    => $command_path,
        unless  => 'which nova',
        notify  => Service['libvirtd'],
        require => Package['libvirt-python', 'qemu-kvm', 'libvirt', 'dnsmasq-utils', 'polkit', 'tunctl', 'dbus', 'dnsmasq', 'bridge-utils', 'libguestfs', 'python-libguestfs', 'libguestfs-tools-c'],
    }

    service { 'libvirtd':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Exec['install python-novaclient'],
    }
}
