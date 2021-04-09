define vs_devops::subsystems::hashicorp::vaultService (
    String $vaultPort   = '8200',
    String $vaultConfig = '/etc/vault/config.hcl',
    String $homeDir     = '/home/vagrant',
    String $dataPath    = '/var/lib/vault',
) {
    File { '/etc/vault':
        ensure  => directory,
    } ->
    File { "${dataPath}":
        ensure  => directory,
    } ->
    File { "/etc/vault/config.hcl":
        ensure  => file,
        path    => "/etc/vault/config.hcl",
        content => template( 'vs_devops/hashicorp/vault_config.hcl.erb' ),
        mode    => '0755',
    } ->
    File { "${name}.service":
        ensure  => file,
        path    => "/etc/systemd/system/${name}.service",
        content => template( 'vs_devops/hashicorp/vault.service.erb' ),
        mode    => '0755',
    } ->
    Service { "Start Service: ${name}":
        name    => "${name}",
        ensure  => 'running',
    }
    
    stage { 'vault-setup': }
    Stage['main'] -> Stage['vault-setup']
    class { '::vs_devops::subsystems::hashicorp::vaultSetup':
        vaultPort   => $vaultPort,
        stage       => 'vault-setup',
    }
}