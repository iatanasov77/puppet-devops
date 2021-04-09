class vs_devops::subsystems::hashicorp::vaultEnvironment (
    String $vaultPort   = '8200',
) {
    Exec { 'Setup Vault':
        command => "/usr/bin/php /vagrant/bin/vault_setup.php",
    }
}
