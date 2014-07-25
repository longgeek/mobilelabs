class nova-control::sources {
    file { "$sources_dir/tar/nova.zip":
        source => 'puppet:///files/sources/nova.zip',
        notify => Exec['untar nova.zip'],
    }

    exec { 'untar nova.zip':
        command     => "unzip $sources_dir/tar/nova.zip -d $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install nova'],
        require     => File["$sources_dir/tar/nova.zip"],
    }

    exec { 'install nova':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/nova/",
        timeout     => '0',
        tries       => '1',
        refreshonly => true,
        require     => Exec['untar nova.zip'],
    }
}
