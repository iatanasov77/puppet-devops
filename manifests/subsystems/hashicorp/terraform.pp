class vs_devops::subsystems::hashicorp::terraform (
    String $version = 'latest',
) {
    /*
    class { hashicorp::terraform:
        version   => $version,
    }
    */
    package { 'terraform':
        ensure  => installed,
        require => Class['Hashi_stack::Repo'],
    }
}
