##########################################################################################
# https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-ui
# https://blog.vivekv.com/hashicorp-vault-systemd-startup-script.html
##########################################################################################
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
        path    => "${vaultConfig}",
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
        ensure  => running,
        enable  => true,
    }
}