define vs_devops::subsystems::jenkins::credentialXml (
    String $crdId,
    Hash $config,
) {
    if ! ( $config['type'] in [ 'SSHUserPrivateKey', 'UsernamePassword', 'VaultToken', 'SecretText' ] ) {
       fail( 'Unknown Credentials Type !!!' )
    }
    
    if $config['plugin'] {
        $crdPlugin      = $config['plugin']
    }
    
    if $config['username'] {
        $crdUsername    = $config['username']
    }
    
    if $config['password'] {
        $crdPassword    = $config['password']
    }
    
    if $config['passphrase'] {
        $crdPassphrase  = $config['passphrase']
    }
    
    if $config['privateKey'] {
        $crdPrivateKey  = $config['privateKey']
    }
    
    if $config['vaultToken'] {
        $crdVaultToken  = $config['vaultToken']
    }
    
    if $config['secret'] {
        $crdSecret  = $config['secret']
    }
    
    File { "/tmp/jenkins-credential-${crdId}.xml":
        ensure  => file,
        content => template( "vs_devops/jenkins/credentials/${config['type']}.xml.erb" ),
    }
}
