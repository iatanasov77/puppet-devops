class vs_devops::subsystems::hashicorp::vaultSetup (
    String $vaultPort   = '8200',
    /* Path to the Json file with secrets */
    String $secretsData = '',
) {
    Exec { 'Setup Vault':
        command => "/usr/bin/php /vagrant/vault.d/vault_setup.php -p${vaultPort} -d${secretsData}",
    }
}
