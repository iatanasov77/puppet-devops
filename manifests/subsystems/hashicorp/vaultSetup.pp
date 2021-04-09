class vs_devops::subsystems::hashicorp::vaultSetup (
    String $vaultPort   = '8200',
) {
    Exec { 'Setup Vault':
        command => "/usr/bin/php /vagrant/bin/vault_setup.php -p${vaultPort}",
    }
}
