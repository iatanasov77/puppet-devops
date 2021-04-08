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
    }  ->
    Exec { 'Initialize Vault':
        command => "curl --request POST --data '{\"secret_shares\": 1, \"secret_threshold\": 1}' http://127.0.0.1:${vaultPort}/v1/sys/init > /tmp/vault_init.json",
        user    => 'vagrant',
        timeout    => 1800,
        tries      => 10,
    } ->
    class { '::vs_devops::subsystems::hashicorp::vaultEnvironment':
        vaultPort   => $vaultPort,
    }
}