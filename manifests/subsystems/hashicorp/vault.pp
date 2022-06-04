class vs_devops::subsystems::hashicorp::vault (
    String $version = 'latest',
    Hash $config    = { port => '8200' }
) {
    package { 'vault':
        ensure  => installed,
        require => Class['Hashi_stack::Repo'],
    } ->
    vs_devops::subsystems::hashicorp::vaultService { 'vault':
        vaultPort   => "${config['port']}",
    }
}