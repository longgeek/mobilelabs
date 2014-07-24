class nova-control::sources {
    file { "$sources_dir/tar/nova.tar.gz":
        source => 'puppet:///files/sources/nova.tar.gz',
        notify => Exec['untar nova.tar.gz'],
    }

    exec { 'untar nova.tar.gz':
        command     => "tar zxvf $sources_dir/tar/nova.tar.gz -C $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install nova'],
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
    }
}
