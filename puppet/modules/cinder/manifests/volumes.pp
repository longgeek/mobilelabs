class cinder::volumes {
    exec { 'create volumes backing file':
        command => 'dd if=/dev/zero of=/etc/cinder/volumes/thstack-volumes-backing-file bs=1 count=0 seek=50G',
        path    => $command_path,
        unless  => "[ -e /etc/cinder/volumes/thstack-volumes-backing-file ]",
        notify  => Exec['losetup loop7'],
    }

    exec { 'losetup loop7':
        command => 'losetup /dev/loop7 /etc/cinder/volumes/thstack-volumes-backing-file',
        path    => $command_path,
        unless  => 'losetup -a | grep thstack-volumes-backing-file',
        notify  => [Exec['create thstack-volumes'], Class['cinder::services']],
    }

    exec { 'create thstack-volumes':
        command => 'parted /dev/loop7 -s mklabel msdos && \
                    parted /dev/loop7 -s mkpart primary 0 100% && \
                    parted /dev/loop7 toggle 1 lvm && \
                    pvcreate /dev/loop7 && \
                    vgcreate thstack-volumes /dev/loop7',
        path    => $command_path,
        unless  => 'vgs | grep thstack-volumes',
        notify  => Class['cinder::services'],
    }
}
