class cinder::sources {
    file { "$sources_dir/tar/cinder.tar.gz":
        source => 'puppet:///files/sources/cinder.tar.gz',
        notify => Exec['untar cinder.tar.gz'],
    }

    exec { 'untar cinder.tar.gz':
        command     => "tar zxvf $sources_dir/tar/cinder.tar.gz -C $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install cinder'],
    }

    exec { 'install cinder':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/cinder/",
        refreshonly => true,
    }
}
