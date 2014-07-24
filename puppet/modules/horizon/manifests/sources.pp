class horizon::sources {
    file { "$sources_dir/tar/horizon.tar.gz":
        source => 'puppet:///files/sources/horizon.tar.gz',
        notify => Exec['untar horizon.tar.gz'],
    }

    exec { 'untar horizon.tar.gz':
        command     => "tar zxvf $sources_dir/tar/horizon.tar.gz -C $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install horizon'],
    }

    exec { 'install horizon':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/horizon/",
        refreshonly => true,
    }
}
