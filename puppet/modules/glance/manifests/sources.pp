class glance::sources {
    file { "$sources_dir/tar/glance.zip":
        source => 'puppet:///files/sources/glance.zip',
        notify => Exec['untar glance.zip'],
    }

    exec { 'untar glance.zip':
        command     => "unzip $sources_dir/tar/glance.zip -d $sources_dir/sources/",
        path        => $command_path,
        refreshonly => true,
        require     => File["$sources_dir/tar/glance.zip"],
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
        require     => Exec['untar glance.zip'],
    }
}
