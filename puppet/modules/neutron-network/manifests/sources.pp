class neutron-network::sources {
    file { "$sources_dir/tar/neutron.zip":
        source => 'puppet:///files/sources/neutron.zip',
        notify => Exec['untar neutron.zip'],
    }

    exec { 'untar neutron.zip':
        command     => "unzip $sources_dir/tar/neutron.zip -d $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        require     => File["$sources_dir/tar/neutron.zip"],
        notify      => Exec['install neutron'],
    }

    exec { 'install neutron':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/neutron/",
        require     => Exec['untar neutron.zip'],
        refreshonly => true,
    }
}
