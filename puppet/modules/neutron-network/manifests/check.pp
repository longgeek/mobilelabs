class neutron-network::check {
    exec { 'check openvswitch':
        command => '/etc/init.d/neutron-openvswitch-agent restart',
        path    => $command_path,
        onlyif  => "tail -n 10 /var/log/neutron/openvswitch-agent.log | grep 'sudo: sorry, you must have a tty to run sudo'",
    }
}
