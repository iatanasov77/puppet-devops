class vs_devops::subsystems::hashicorp::packer (
    String $version = 'latest',
) {
    /*
    class { hashicorp::packer:
        version   => $version,
    }
    */
    package { 'packer':
        ensure  => installed,
        require => Class['Hashi_stack::Repo'],
    }
}
