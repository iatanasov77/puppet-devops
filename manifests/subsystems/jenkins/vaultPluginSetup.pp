class vs_devops::subsystems::jenkins::vaultPluginSetup (
    $jenkinsCli,
    Hash $config = {}
) {
    $vaultKeys  = loadjson( '/vagrant/gui/var/vault.json' )
    $vaultConfig    = {
        'type'          => 'VaultToken',
        'plugin'        => 'hashicorp-vault-plugin@360.v0a_1c04cf807d',
        'vaultToken'    => "${$vaultKeys['root_token']}",
        'vaultUrl'      => "http://${hostname}:${config['vaultPort']}"
    };
    
    /*
     * Setup VaultToken Credential
     */
    vs_devops::subsystems::jenkins::credentialXml { "jenkins-credential-vault-token":
        crdId   => 'vault-token',
        config  => $vaultConfig,
    } ->
    Exec { "Set PrivateKey for: vault-token":
        command => "/usr/bin/php /opt/vs_devops/replace_private_key.php -ivault-token",
    } ->
    Exec { "Add Global Credential: vault-token":
        command    => "/usr/bin/java -jar ${jenkinsCli} -s http://localhost:8080/ \
                        create-credentials-by-xml system::system::jenkins _  < /tmp/jenkins-credential-vault-token.xml",
        timeout    => 1800,
        tries      => 3,
    }
    
    /*
     * Setup Vault Plugin
     */
    -> File { '/var/lib/jenkins/com.datapipe.jenkins.vault.configuration.GlobalVaultConfiguration.xml':
        ensure  => file,
        content => template( 'vs_devops/jenkins/libraries/GlobalVaultConfiguration.xml.erb' ),
        mode    => '0644',
        owner   => 'jenkins',
        group   => 'jenkins',
    }
    
    -> Exec { 'Jenkins Service Restart After Vault Plugin Setup':
        command => 'service jenkins restart',
    }
}