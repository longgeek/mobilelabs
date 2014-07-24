class neutron-compute::sources {

    file { "$sources_dir/tar/neutron.tar.gz":
        source => 'puppet:///files/sources/neutron.tar.gz',
        notify => Exec['untar neutron.tar.gz'],
    }

    exec { 'untar neutron.tar.gz':
        command     => "tar zxvf $sources_dir/tar/neutron.tar.gz -C $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install neutron'],
    }

    exec { 'install neutron':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/neutron/",
        refreshonly => true,
    }
}
