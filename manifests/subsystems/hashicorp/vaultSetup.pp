class vs_devops::subsystems::hashicorp::vaultSetup (
    String $port,
    String $secrets,
) {
    $file_exists    = find_file( $secrets )
    if ( $file_exists ) {
        /* Execute Setup Script */
        Exec { 'Setup Vault':
            command => "/usr/bin/php /opt/vs_devops/vault_setup.php -p${port} -d '${secrets}'",
        }
    } else {
        file { 'vault_secrets':
            path    => "${secrets}",
            content => template( 'vs_devops/hashicorp/secrets.json.erb' ),
        } ->
        
        /* Execute Setup Script */
        Exec { 'Setup Vault':
            command => "/usr/bin/php /opt/vs_devops/vault_setup.php -p${port} -d '${secrets}'",
        }
    }
}
