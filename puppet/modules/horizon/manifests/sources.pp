class horizon::sources {
    file { "$sources_dir/tar/horizon.zip":
        source => 'puppet:///files/sources/horizon.zip',
        notify => Exec['untar horizon.zip'],
    }

    exec { 'untar horizon.zip':
        command     => "unzip $sources_dir/tar/horizon.zip -d $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        require     => File["$sources_dir/tar/horizon.zip"],
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
        require     => Exec['untar horizon.zip'],
    }
}
