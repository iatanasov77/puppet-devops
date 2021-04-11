class vs_devops::subsystems::hashicorp::vaultSetup (
    /* Setup Script */
    String $vaultSetup = '/usr/bin/php /vagrant/vault.d/vault_setup.php',
) {
    Exec { 'Setup Vault':
        command => "${vaultSetup}",
    }
}
