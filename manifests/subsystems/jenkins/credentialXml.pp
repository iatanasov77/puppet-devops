define vs_devops::subsystems::jenkins::credentialXMl (
    String $crdId,
    Hash $config,
) {
    $crdUsername    = $config['username']
    
    if $config['plugin'] {
        $crdPlugin      = $config['plugin']
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
    

    File { "/tmp/jenkins-credential-${crdId}.xml":
        ensure  => file,
        content => template( "vs_devops/jenkins/credentials/${config['type']}.xml.erb" ),
    }
}
