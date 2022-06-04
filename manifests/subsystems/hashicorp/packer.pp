class vs_devops::subsystems::hashicorp::packer (
    String $version = 'latest',
) {
    package { 'packer':
        ensure  => installed,
        require => Class['Hashi_stack::Repo'],
    }
}
