class glance::sources {
    file { "$sources_dir/tar/glance.tar.gz":
        source => 'puppet:///files/sources/glance.tar.gz',
        notify => Exec['untar glance.tar.gz'],
    }

    exec { 'untar glance.tar.gz':
        command     => "tar zxvf $sources_dir/tar/glance.tar.gz -C $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        notify      => Exec['install glance'],
    }

    exec { 'install glance':
        command     => "git checkout stable/icehouse && \
                        python setup.py egg_info && \
                        pip install -r *.egg-info/requires.txt && \
                        python setup.py develop",
        path        => $command_path,
        cwd         => "$sources_dir/sources/glance/",
        refreshonly => true,
    }
}
