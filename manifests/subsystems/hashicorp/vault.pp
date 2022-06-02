class vs_devops::subsystems::hashicorp::vault (
    String $version     = 'latest',
    String $vaultPort   = '0000',
) {
    /*
    class { hashicorp::vault:
        version   => $version,
    }
    */
    package { 'vault':
        ensure  => installed,
        require => Class['Hashi_stack::Repo'],
    } ->
    vs_devops::subsystems::hashicorp::vaultService { 'vault':
        vaultPort   => "${vaultPort}",
    }
}