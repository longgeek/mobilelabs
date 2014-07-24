class keystone::sources {

    file { "$sources_dir/tar/keystone.tar.gz":
        source => 'puppet:///files/sources/keystone.tar.gz',
        notify => Exec['untar keystone.tar.gz'],
    }

    exec { 'untar keystone.tar.gz':
        command     => "tar zxvf $sources_dir/tar/keystone.tar.gz -C $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install keystone'],
    }

    exec { 'install keystone':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/keystone/",
        refreshonly => true,
    }
}
