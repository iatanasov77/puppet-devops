class vs_devops::subsystems::hashicorp::vaultSetup (
    String $port,
    String $secrets,
) {
    /* Execute Setup Script */
    Exec { 'Setup Vault':
        command => "/usr/bin/php /opt/vs_devops/vault_setup.php -p${port} -d '${secrets}'",
    }
}
