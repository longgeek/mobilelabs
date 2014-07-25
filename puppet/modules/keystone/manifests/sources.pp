class keystone::sources {

    file { "$sources_dir/tar/keystone.zip":
        source => 'puppet:///files/sources/keystone.zip',
        notify => Exec['untar keystone.zip'],
    }

    exec { 'untar keystone.zip':
        command     => "unzip $sources_dir/tar/keystone.zip -d $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install keystone'],
        require     => File["$sources_dir/tar/keystone.zip"],
    }

    exec { 'install keystone':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/keystone/",
        refreshonly => true,
        require     => Exec['untar keystone.zip'],
    }
}
